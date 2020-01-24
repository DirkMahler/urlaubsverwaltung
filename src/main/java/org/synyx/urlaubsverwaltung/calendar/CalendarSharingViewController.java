package org.synyx.urlaubsverwaltung.calendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Optional;


@Controller
@RequestMapping("/web/persons/{personId}/calendar/share")
public class CalendarSharingViewController {

    private final PersonCalendarService personCalendarService;

    @Autowired
    public CalendarSharingViewController(PersonCalendarService personCalendarService) {
        this.personCalendarService = personCalendarService;
    }

    @GetMapping
    public String index(@PathVariable int personId, Model model) {

        final PersonCalendarDto dto = new PersonCalendarDto();
        dto.setPersonId(personId);

        final Optional<PersonCalendar> maybePersonCalendar = personCalendarService.getPersonCalendar(personId);
        if (maybePersonCalendar.isPresent()) {
            final PersonCalendar personCalendar = maybePersonCalendar.get();
            dto.setCalendarUrl("https://urlaubsverwaltung.cloud/calendar/" + personCalendar.getSecret());
        }

        model.addAttribute("privateCalendarShare", dto);

        return "calendarsharing/index";
    }

    @PostMapping(value = "/me")
    public String linkPrivateCalendar(@PathVariable int personId) {

        personCalendarService.createCalendarForPerson(personId);

        return String.format("redirect:/web/persons/%d/calendar/share", personId);
    }

    @PostMapping(value = "/me/{calendarId}", params = "unlink")
    public String unlinkPrivateCalendar(@PathVariable int personId) {

        personCalendarService.deletePersonalCalendarForPerson(personId);

        return String.format("redirect:/web/persons/%d/calendar/share", personId);
    }
}
