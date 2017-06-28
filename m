From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Wed, 28 Jun 2017 09:43:40 +0000
Message-ID: <1498643018.3575.4.camel@wdc.com>
References: <20170620074639.GP17846@mtr-leonro.local>
         <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me>
         <20170620083309.GQ17846@mtr-leonro.local>
         <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me>
         <614481c7-22dd-d93b-e97e-52f868727ec3@grimberg.me>
         <59FF0C04-2BFB-4F66-81BA-A598A9A087FC@oracle.com>
         <20170620173532.GA827@obsidianresearch.com>
         <D3DC49A2-FFC9-4F62-8876-3E6AD5167DE5@oracle.com>
         <20170620192742.GB827@obsidianresearch.com>
         <C14B071E-F1B2-466A-82CF-4E20BFAD9DC1@oracle.com>
         <20170620211958.GA5574@obsidianresearch.com>
         <4f0812f1-0067-4e63-e383-b913ee1f319d@grimberg.me>
         <1498586933.14963.1.camel@wdc.com>
         <47bbf598-6c82-610f-dc1d-706a1d869b8d@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47bbf598-6c82-610f-dc1d-706a1d869b8d-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <C7DE4A4A3974C14C96F422A7A5505123-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-06-28 at 10:16 +0300, Sagi Grimberg wrote:
> BTW, did the efforts on standardizing remote invalidate in SRP ever
> evolved to something? Would it be acceptable to add a non-standard
> ib_srp and ib_srpt? We can default to off and allow the user to opt
> it in if it knows the two sides comply...

I'd like to hear Doug's opinion about whether it's OK to add this
feature to the upstream drivers before support for remote invalidate
is standardized.

> We need to fix that in nvmf and iser too btw (luckily we have remote
> invalidate so its not a big issue).
>=20
> > The upstream SRP initiator does not use inline data.
>=20
> Yet :)
>=20
> IIRC you have a branch with immediate-data support against scst so
> it might be relevant there...

Support for immediate data is being standardized. My plan is to add
support for immediate data to the upstream drivers once the T10 committee
agrees about the implementation. See also
http://www.t10.org/cgi-bin/ac.pl?t=3Df&f=3Dsrp2r02a.pdf

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
