package org.synyx.urlaubsverwaltung.calendar;

import org.apache.logging.log4j.util.Strings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.synyx.urlaubsverwaltung.absence.AbsenceService;
import org.synyx.urlaubsverwaltung.calendarintegration.absence.Absence;
import org.synyx.urlaubsverwaltung.person.Person;
import org.synyx.urlaubsverwaltung.person.PersonService;

import java.util.List;
import java.util.Optional;


@Service
class PersonCalendarService {

    private final AbsenceService absenceService;
    private final PersonService personService;
    private final PersonCalendarRepository personCalendarRepository;
    private final ICalService iCalService;

    @Autowired
    PersonCalendarService(AbsenceService absenceService, PersonService personService,
                          PersonCalendarRepository personCalendarRepository, ICalService iCalService) {

        this.absenceService = absenceService;
        this.personService = personService;
        this.personCalendarRepository = personCalendarRepository;
        this.iCalService = iCalService;
    }

    String getCalendarForPerson(Integer personId, String secret) {

        if (Strings.isBlank(secret)) {
            throw new IllegalArgumentException("secret must not be empty.");
        }

        final PersonCalendar calendar = personCalendarRepository.findBySecret(secret);
        if (calendar == null) {
            throw new IllegalArgumentException("No calendar found for secret=" + secret);
        }

        final Optional<Person> optionalPerson = personService.getPersonByID(personId);
        if (optionalPerson.isEmpty()) {
            throw new IllegalArgumentException("No person found for ID=" + personId);
        }

        final Person person = optionalPerson.get();

        if (!calendar.getPerson().equals(person)) {
            throw new IllegalArgumentException(String.format("Secret=%s does not match the given personId=%s", secret, personId));
        }

        final String title = "Abwesenheitskalender von " + person.getNiceName();
        final List<Absence> absences = absenceService.getOpenAbsences(List.of(person));

        return iCalService.generateCalendar(title, absences);
    }
}
