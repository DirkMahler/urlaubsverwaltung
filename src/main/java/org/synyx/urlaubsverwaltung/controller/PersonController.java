
package org.synyx.urlaubsverwaltung.controller;

import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import org.synyx.urlaubsverwaltung.domain.Antrag;
import org.synyx.urlaubsverwaltung.domain.Person;
import org.synyx.urlaubsverwaltung.service.AntragService;
import org.synyx.urlaubsverwaltung.service.PersonService;

import java.util.Calendar;
import java.util.Date;
import java.util.List;


/**
 * @author  aljona
 */
public class PersonController {

    private PersonService personService;
    private AntragService antragService;

    public PersonController(PersonService personService, AntragService antragService) {

        this.personService = personService;
        this.antragService = antragService;
    }

    public Integer getYear() {

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date()); // heute

        Integer year = cal.get(Calendar.YEAR);

        return year;
    }


    @RequestMapping(value = "/mitarbeiter", method = RequestMethod.GET)
    public String showMitarbeiterList(Model model) {

        List<Person> mitarbeiter = personService.getAllPersons();

        model.addAttribute("mitarbeiter", mitarbeiter);

        return "mitarbeiter";
    }


    @RequestMapping(value = "/{mitarbeiterId}/overview", method = RequestMethod.GET)
    public String showOverview(@PathVariable("mitarbeiterId") Integer mitarbeiterId, Model model) {

        Person person = personService.getPersonByID(mitarbeiterId);

        List<Antrag> requests = antragService.getAllRequestsForPerson(person);

        model.addAttribute("year", getYear());
        model.addAttribute("requests", requests);
        model.addAttribute("person", person);

        return "overview";
    }
}
