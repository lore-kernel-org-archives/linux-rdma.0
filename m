From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Thu, 18 May 2017 16:34:39 +0300
Message-ID: <20170518133439.GD3616@mtr-leonro.local>
References: <33e2cc35-f147-d4a4-9a42-8f1245e35842@mellanox.com>
 <DE927C68B458BE418D582EC97927A92855088C6F@ORSMSX113.amr.corp.intel.com>
 <82dd5b24-5657-ae5e-8a33-646fddd8b75b@grimberg.me>
 <20170515133122.GG3616@mtr-leonro.local>
 <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
 <20170515143632.GH3616@mtr-leonro.local>
 <20170515145952.GA7871@infradead.org>
 <20170515170506.GK3616@mtr-leonro.local>
 <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="V6UBx4j9pGkVmsf8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <779753075.36035391.1495025796237.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--V6UBx4j9pGkVmsf8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 17, 2017 at 02:56:36PM +0200, Marta Rybczynska wrote:
> > On Mon, May 15, 2017 at 07:59:52AM -0700, Christoph Hellwig wrote:
> >> On Mon, May 15, 2017 at 05:36:32PM +0300, Leon Romanovsky wrote:
> >> > I understand you and both Max and me are feeling the same as you. For more
> >> > than 2 months, we constantly (almost on daily basis) asked for a solution from
> >> > architecture group, but received different answers. The proposals were
> >> > extremely broad from need for strong fence for all cards to no need for
> >> > strong fence at all.
> >>
> >> So let's get the patch to do a strong fence everywhere now, and relax
> >> it later where possible.
> >>
> >> Correntness before speed..
> >
> > OK, please give me and Max till EOW to stop this saga. One of the two
> > options will be: Max will resend original patch, or Max will send patch
> > blessed by architecture group.
> >
>
> Good luck with this Max & Leon! It seems to be a complicated problem.
> Just an idea: in our case it *seems* that the problem started appearing
> after a firmware upgrade, older ones do not seem to have the same
> behaviour. Maybe it's a hint for you.

OK, we came to the agreement which capability bits we should add. Max
will return to the office at the middle of the next week and we will
proceed with the submission of proper patch once our shared code will
be accepted.

In the meantime, i put the original patch to be part of our regression.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=testing/queue-next&id=a40ac569f243db552661e6efad70080bb406823c

Thank you for your patience.

>
> Thanks!
> Marta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--V6UBx4j9pGkVmsf8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkdou8ACgkQ5GN7iDZy
WKeQgw//eaYSYird+k5p47DqpEkjsGl2yi1gMAHH6iHaPzBz77wFSTq2l6Z68NW/
h3LeGYaLnIEJAbSqY9+aR5Tt5ifzGkbLaizsk7/0tnvR81LFrky0bSNK9F+BUhIA
OCqZRzy99NjvzqYMvzmqv9Q/MAtPO1ddjIcQno7fxNrd0VAePDv4K3EuSkM8dxUC
5xZelvZhuVtAi1ykBDFaaQSEt3SP3O+ci+rvnJ7sG2yo0E4596QtIJeV1kxG7gwd
MWPDTLhcepdFlXqht+qc0+40ufO2aH22KSYM624Zay5iVhCeRcwsf5p2lWAtUCl6
hrc1fyggac5jRgMkTa1e3NlmdLQFYB8Bb6ThTvLsxL5J+1p5FOXOP+ZjkN4KLGH5
dY+5QpzQdZcjG9gwCYMSde8eQyPIdk8Y3k0YhwYV86Wqd6OeM1rhGwb3crMmV9/s
D6KBA5okk8/K2KGHnWlMWR33vhCpDUPICZTzTh0+HR3QEdvEKZLd1/L7mcyyFDgp
8rgk0F94GIclJkYMz650CMijZw8pMUZLnKVa1WQ+mfkpoeJKeI08WtTqgN0wnv7g
jIRryLXz8DWDfxyQ7u0KiHVaxib++/4dct8//FMAcEULvAOWpoaTj3xWRypTTd66
qPj4aKUhnoGxORScuFsf6bnvQpk3BdB12HMl48n5LLLqsSTg06A=
=PLQG
-----END PGP SIGNATURE-----

--V6UBx4j9pGkVmsf8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
