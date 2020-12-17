import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import static java.util.Arrays.stream;
import java.util.Comparator;

class Day16 {
    private Ticket myTicket;
    private final Rule[] rules;
    private Ticket[] nearbyTickets;

    private Day16() throws IOException {
        String content = new String(Files.readAllBytes(Paths.get("input.txt")));

        // Input in split into three sections
        String[] parts = content.split("\n\n");

        // Section 1, rules
        String[] lines = parts[0].split("\n");
        this.rules = stream(lines).map(s -> new Rule(s)).toArray(Rule[]::new);

        // Section 2, my ticket
        this.myTicket = new Ticket(parts[1].split("\n")[1]);

        // Section 3, nearby tickets
        String[] ticketStrings = parts[2].split("\n");
        this.nearbyTickets = stream(ticketStrings).skip(1).map(s -> new Ticket(s)).toArray(Ticket[]::new);
    }

    private void part1() {
        long sum = 0;
        for (Ticket nearby : nearbyTickets) {
            sum += nearby.sumInvalid();
        }

        System.out.println("Part 1: " + sum);
    }

    private void part2() {
        List<Ticket> validTickets = stream(nearbyTickets).filter(ticket -> ticket.sumInvalid() == 0)
                .collect(Collectors.toList());
        for (Ticket t : validTickets) {
            for (int i = 0; i < t.values.length; i++) {
                for (Rule r : rules) {
                    if (!r.isValid(t.values[i])) {
                        r.invalidateRow(i);
                    }
                }
            }
        }

        List<Rule> sortedRules = stream(rules).sorted(Comparator.comparing(rule -> rule.getEqualFields().length))
                .collect(Collectors.toList());
        for (int i = 0; i < sortedRules.size(); i++) {
            int[] equalFields = sortedRules.get(i).getEqualFields();
            if (equalFields.length == 0) {
                continue;
            }
            int otherInvalid = equalFields[0];
            for (int j = i + 1; j < sortedRules.size(); j++) {
                sortedRules.get(j).invalidateRow(otherInvalid);
            }
        }

        long product = 1;
        for (Rule rule: sortedRules) {
            if (rule.name.startsWith("departure")) {
                product *= myTicket.values[rule.getEqualFields()[0]];
            }
        }

        System.out.println("Part 2: " + product);
    }

    private boolean isValidValue(long value) {
        for (Rule f : rules) {
            if (f.isValid(value))
                return true;
        }
        return false;
    }

    private class Ticket {
        long[] values;

        private Ticket(String input) {
            values = Arrays.stream(input.split(",")).mapToLong(Integer::parseInt).toArray();
        }

        private long sumInvalid() {
            long invalid = 0;
            for (long value : values) {
                if (isValidValue(value)) {
                    continue;
                }
                invalid += value;
            }
            return invalid;
        }
    }

    private class Rule {
        private String name;
        private Ranges ranges;
        private int[] equalIndices;

        private Rule(String input) {
            long[] ranges = new long[] { 0, 0, 0, 0 };
            String[] inp = input.split(": ");
            this.name = inp[0];

            String[] ranges_split = inp[1].split(" or ");
            for (int i = 0; i < ranges_split.length; i++) {
                ranges[i * 2] = Integer.parseInt(ranges_split[i].split("-")[0]);
                ranges[i * 2 + 1] = Integer.parseInt(ranges_split[i].split("-")[1]);
            }
            this.ranges = new Ranges(ranges);

            this.equalIndices = new int[20];
            for (int i = 0; i < 20; i++) {
                equalIndices[i] = i;
            }
        }

        private boolean isValid(long num) {
            return (num >= ranges.r1Min && num <= ranges.r1Max) || (num >= ranges.r2Min && num <= ranges.r2Max);
        }

        private void invalidateRow(int row) {
            equalIndices[row] = -1;
        }

        private int[] getEqualFields() {
            return Arrays.stream(equalIndices).filter(value -> value != -1).toArray();
        }
    }

    private class Ranges {
        long r1Min;
        long r1Max;
        long r2Min;
        long r2Max;

        private Ranges(long[] ranges) {
            r1Min = ranges[0];
            r1Max = ranges[1];
            r2Min = ranges[2];
            r2Max = ranges[3];
        }
    }

    public static void main(String[] args) {
        try {
            Day16 runner = new Day16();
            runner.part1();
            runner.part2();
        } catch (IOException e) {
            System.err.println(e);
        }
    }
}
