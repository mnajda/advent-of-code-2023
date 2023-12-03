using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

namespace part1;

using Number = (int start, int end, int y);
using Point = (int x, int y);

class Program
{
    record PossiblePartNumber(Number number, List<Point> points);

    static String[] ReadFile(string path)
    {
        using (var reader = new StreamReader(path))
        {
            return reader.ReadToEnd().Split("\n");
        }
    }

    static Number FindNumber(int x, int y, int maxX, String input)
    {
        var start = x;
        while (Char.IsDigit(input, x))
        {
            x++;
            if (x >= maxX)
            {
                break;
            }
        }

        return (start, x - 1, y);
    }

    static List<Point> GenerateFieldsToCheck(Number span, int y, int maxX, int maxY)
    {
        var (start, end, _) = span;
        var fieldsToCheck = new List<Point>();

        if (start - 1 >= 0)
        {
            fieldsToCheck.Add((start - 1, y));
        }

        if (end + 1 < maxX)
        {
            fieldsToCheck.Add((end + 1, y));
        }

        if (y - 1 > 0)
        {
            if (start - 1 >= 0)
            {
                fieldsToCheck.Add((start - 1, y - 1));
            }

            if (end + 1 < maxX)
            {
                fieldsToCheck.Add((end + 1, y - 1));
            }

            for (int i = start; i < end + 1; i++)
            {
                fieldsToCheck.Add((i, y - 1));
            }
        }

        if (y + 1 < maxY)
        {
            if (start - 1 >= 0)
            {
                fieldsToCheck.Add((start - 1, y + 1));
            }

            if (end + 1 < maxX)
            {
                fieldsToCheck.Add((end + 1, y + 1));
            }

            for (int i = start; i < end + 1; i++)
            {
                fieldsToCheck.Add((i, y + 1));
            }
        }

        return fieldsToCheck;
    }

    static int Solve(String[] input)
    {
        var partNumbers = new List<int>();

        var maxX = input.Length;
        var maxY = input[0].Length;

        var possiblePartNumbers = new List<PossiblePartNumber>();

        for (var y = 0; y < maxY; y++)
        {
            for (var x = 0; x < maxX; x++)
            {
                if (Char.IsDigit(input[y], x))
                {
                    var span = FindNumber(x, y, maxX, input[y]);
                    x = span.Item2;

                    var toCheck = GenerateFieldsToCheck(span, y, maxX, maxY);

                    possiblePartNumbers.Add(new PossiblePartNumber(span, toCheck));
                }
            }
        }

        foreach (var possiblePartNumber in possiblePartNumbers)
        {
            if (possiblePartNumber.points.Any(point =>
            {
                var (x, y) = point;
                return input[y][x] != '.' && !Char.IsDigit(input[y], x);
            }))
            {
                var (start, end, y) = possiblePartNumber.number;
                partNumbers.Add(Int32.Parse(input[y].Substring(start, end - start + 1)));
            }
        }

        return partNumbers.Sum();
    }

    static void Main(string[] args)
    {
        var input = ReadFile(args[0]);

        var result = Solve(input);

        Console.WriteLine(result);
    }
}
