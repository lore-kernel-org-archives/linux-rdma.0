From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: cqe dump errors on target while running nvme-of large block read
 IO
Date: Thu, 27 Apr 2017 04:29:27 +0000
Message-ID: <209CAF47-1CE4-4A22-9E11-6377CEF62495@mellanox.com>
References: <DE927C68B458BE418D582EC97927A9285505C9EA@ORSMSX113.amr.corp.intel.com>
 <47f19583-1882-09d4-ce1c-534b8e59068b@mellanox.com>
 <DE927C68B458BE418D582EC97927A9285505F0C9@ORSMSX113.amr.corp.intel.com>
 <52c550c1-849b-7ea5-ab34-56543cb9069d@mellanox.com>
 <991b26ec-69d3-9e1c-ed3e-0d6e6618e73a@grimberg.me>
 <DE927C68B458BE418D582EC97927A92855072ECF@ORSMSX113.amr.corp.intel.com>,<8521776c-9557-04f1-9c7c-8389e083052b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8521776c-9557-04f1-9c7c-8389e083052b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 27, 2017, at 2:57 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>=20
>=20
>> Folks, I have to apologize here.  Flow control was at one point configur=
ed correctly, but we had a power outage in our lab two weeks ago.
>> We thought the switch had come back up OK, but late week we were double-=
checking all the ports in use and we found one port had lost some
>> settings and no longer had flow control enabled (it had also reverted fr=
om 100Gb to 50Gb for some reason).  After fixing the port settings
>> we ran IO through the weekend and the early part of this week on a varie=
ty of workloads.  We don't seem to be able to reproduce the failure
>> after fixing the port settings.  It looks like this one may have been ca=
used by the lost flow control setting on the switch.  Sorry for the confusi=
on!
>=20
> Yep, don't expect RoCE to work without flow-control.
Sagi and all,

Starting in next release, for ConnectX-4 and above PFC isn't required as lo=
ng as ECN is enabled.

With current release we also expect to get good results with ECN and no PFC=
.

Joseph - is ECN enabled on your system?

Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
