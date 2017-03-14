From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: libibverbs statistics
Date: Tue, 14 Mar 2017 16:37:45 +0200
Message-ID: <20170314143745.GU2079@mtr-leonro.local>
References: <SN1PR07MB220795B72FC9CB082CCDC384F8210@SN1PR07MB2207.namprd07.prod.outlook.com>
 <AM5PR0502MB3057535C300A4176657E5FAFBD210@AM5PR0502MB3057.eurprd05.prod.outlook.com>
 <CAFgAxU_rOB_xQptt-LqxKpMC=SbsGOL1FbSiK4eY_czu4zpwfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="L/Qt9NZ8t00Dhfad"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU_rOB_xQptt-LqxKpMC=SbsGOL1FbSiK4eY_czu4zpwfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--L/Qt9NZ8t00Dhfad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 14, 2017 at 04:20:56PM +0200, Alex Rosenbaum wrote:
> can Guys suggestion [1] solve your request for packet counters? on QP
> and flow verbs objects.
> and libibprof [2] as preload lib to track verbs API calls and count
> and duration.
> also RDMA_CM netlink [3] to query in-use QP's and some details about
> them. This has kernel support but user-space was never completed
> integration into 'iptoure2'
>
> [1] https://www.spinics.net/lists/linux-rdma/msg47355.html
> [2] https://github.com/mellanox-hpc/libibprof
> [3] http://linux-rdma.vger.kernel.narkive.com/EMsWPDF2/patch-v4-0-6-ib-netlink-interface-and-rdma-cm-exports
>
> Alex
> __________________________________
>   Alex Rosenbaum  | +972-545-234-555
>

It starts REALLY annoying. Can you STOP top-posting?


>
>
> On Thu, Mar 9, 2017 at 3:43 PM, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> > Hi Ram,
> >
> > That sounds like a great idea. Let's try to generalize the idea and see how
> > to attack it. It looks like we need counters/statistics per verbs object. I noticed
> > that you require specific measurements the objects. However - I see several
> > potential issues here:
> > First - if you manage to find a vendor to add those counters/stats  then
> > other vendors might not support it.
> > Second - trying to push counters/stats for which both the community and
> > all the vendor agrees might proves very difficult.
> > Second - it would be difficult to add to the current verbs API hard-coded
> > names of counters/stats, either as strings, variables names or even enum
> > which contains a list of names.
> >
> > Since that's such a good idea. I'll take the weekend to think about it and see
> > if I can offer some kind of generic approach to solving this problem.
> >
> > Guy
> >
> >
> > On Wed, Mar 09, 2017 at 01:37:39PM +0000, Amrani Ram wrote:
> >
> >>Hi All,
> >>I find it useful to have statistics in the user-space library.
> >>For example -
> >>1. Number of post_sends per WR type
> >>2. Number of failed post_sends
> >>3. Number of polled CQs
> >>4. Number of polled CQ errors
> >>5. Number of times other verbs was invoked, per verb
> >>6. Number of currently opened QPs, perhaps  in each state
> >>7. ...
> >>
> >>I'm not sure what mechanism to use to minimize impact on
> >>performance. In the kernel space, for example, the 'per CPU variables'
> >>can be used, but I'm not aware of a similar mechanism in user space.
> >>Any ideas?
> >
> >>Is this is of use and benefit to anyone?
> >>If so, perhaps something like this can be added to libibverbs.
> >
> >>Also of interest is the scope of the statistics. Per my understanding
> >>libibverbs works per context that will be destroyed after the application
> >>terminates. So I'm asking myself, and you, if it is interesting to
> >>store statistics at a higher scope (aggregate contexts)?
> >>Is it interesting to store statistics per-QP?
> >>(note: currently libibverbs doesn't hold the context's QP list)
> >
> >>Thanks,
> >>Ram
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--L/Qt9NZ8t00Dhfad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljIADkACgkQ5GN7iDZy
WKeWCBAApsAOhov8d9QmG/HvZf9MB0WVvrmlsV5dOsQbId+oJobqrfgQPlw/oIm5
N4sDsVUWdx3bPjdDplua0ZIgEAV8dlBHgY1fI2d6ZYyGCcrRHjSjkKLzSTslxnZI
ERJGEIXI99JfpwBkkMDLA+lEkhfy4jmkGxydcbst0vE9T08ebogVDHBpQR25ibq/
kCNkqEgBvwRq8Nq7na0t1NHFLtk6ewJ5Buc9TzioMAPCOlIfXVSw/hlxBsuWOcMa
zPrMTmZ+1qjXkRrSSVlRKO+ebW1574rBGikjW7LCZ6uDSlrAzZFkuxzD44RMOeBB
pbdTsPY6FyTG63k/cA68ZOL3wCTsgg4NwGfLMkOBlPjgYT16KWQwLm50XanQc4ly
DyXexjhinZxSARb4pdTZ12ElH8HaRw3xAepSFAI/JZzdrXE1kpGiroFCjDpHIasq
GIjeny1kSzk6aHhBv4bhtOx2+AgIZahnIyIx0pF7WI5YYe+OAGX6R4nmcoQ8Jb7U
tykdHvAgpZ7kTpiUFfXJrwosAoaZKCbwLHrhF28X7n1ZhQ8JIeYYAF4ApiSGordW
C2Pkel3VkJPhc6R4O0+yZdtlsZo8ayJCknmGGGeu/Vrw0w3+zaSSzYY/Bje6SbA2
4WtZUhpD1lUQ+t4KpIgUrVLmkc17nBlao9m1t/Yoh+15Tw8yOe8=
=0gDO
-----END PGP SIGNATURE-----

--L/Qt9NZ8t00Dhfad--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
