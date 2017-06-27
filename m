From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 27 Jun 2017 18:08:57 +0000
Message-ID: <1498586933.14963.1.camel@wdc.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4f0812f1-0067-4e63-e383-b913ee1f319d-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <DA90CF87A0232C45B8125C3F44E5D5AF-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-06-27 at 10:37 +0300, Sagi Grimberg wrote:
> Jason,
>=20
> > > The issue about the HCA not being able to access the inline
> > > buffer during a retransmit is also not an issue for RPC-
> > > over-RDMA because these buffers are always registered with
> > > the local rdma lkey.
> >=20
> > Exactly.
>=20
> Lost track of the thread...
>=20
>=20
> Indeed you raised this issue lots of times before, and I failed to see
> why its important or why its error prone, but now I do...
>=20
> My apologies for not listening :(
>=20
> We should fix _all_ initiators for it, nvme-rdma, iser, srp
> and xprtrdma (and probably some more ULPs out there)...
>=20
> It also means that we cannot really suppress any send completions as
> that would result in an unpredictable latency (which is not acceptable).
>=20
> I wish we could somehow tell the HCA that it can ignore access fail to a
> specific address when retransmitting.. but maybe its too much to ask...

Hello Sagi,

Can you clarify why you think that the SRP initiator needs to be changed?
The SRP initiator submits the local invalidate work request after the RDMA
write request. According to table 79 "Work Request Operation Ordering" the
order of these work requests must be maintained by the HCA. I think if a HC=
A
would start with invalidating the MR before the remote HCA has acknowledged
the written data that that's a firmware bug.

The upstream SRP initiator does not use inline data.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
