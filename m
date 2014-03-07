From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux rdma 3.14 merge plans
Date: Fri, 7 Mar 2014 11:31:50 -0800
Message-ID: <CAL1RGDXRCZafDcFsbiG823VQ7_AVZeZqxY8JEaj=oCYRteAw_A@mail.gmail.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
 <CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
 <52CD1C68.4050406@mellanox.com> <1389645171.5567.459.camel@haakon3.risingtidesystems.com>
 <1389820541.5567.543.camel@haakon3.risingtidesystems.com> <CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
 <1389906852.5567.668.camel@haakon3.risingtidesystems.com> <CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
 <1390102949.5567.749.camel@haakon3.risingtidesystems.com> <52DBB4F1.4020400@mellanox.com>
 <CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
 <CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
 <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
 <1390375658.5567.917.camel@haakon3.risingtidesystems.com> <1391731323.14985.56.camel@haakon3.risingtidesystems.com>
 <CAG4TOxNpnMMR-vfAVa+m6f-z82msxygADUkJ7mmrKtzHCOqdhA@mail.gmail.com>
 <1394013249.19539.17.camel@haakon3.risingtidesystems.com> <CAG4TOxNRkAUH5Jsd67--ydWtUJqE1=pnVSuorgn4vNQiuYx1wg@mail.gmail.com>
 <1394046218.20601.12.camel@haakon3.risingtidesystems.com> <EE7902D3F51F404C82415C4803930ACD3FDDD50E@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD3FDDD50E-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hefty Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sure, no problem.

Do you have a git tree with the latest versions of all the changes you
want for 3.15 in a branch?  That would be helpful as I catch up on
applying things, so that I don't miss anything.

If you don't have one, taking a little time to set one up on github or
wherever would be nice.  You can base your set of changes on Linus's
latest tree.

Thanks!
  Roland

On Thu, Mar 6, 2014 at 9:07 PM, Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Roland,
>
> Is it okay to send next series of patches even if previous series is not accepted yet in your tree? Off-course I will cut patches on top of previous series of patches.
>
> -Regards
>  Devesh
>
> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Nicholas A. Bellinger
> Sent: Thursday, March 06, 2014 12:34 AM
> To: Roland Dreier
> Cc: Or Gerlitz; Hefty Sean; linux-rdma; Martin K. Petersen; target-devel; Sagi Grimberg; linux-kernel
> Subject: Re: linux rdma 3.14 merge plans
>
> On Wed, 2014-03-05 at 07:18 -0800, Roland Dreier wrote:
>> On Wed, Mar 5, 2014 at 1:54 AM, Nicholas A. Bellinger
>> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>> > That all said, do you have an objection wrt taking this bits through
>> > target-pending..?  Given the dependencies involved, that would seem
>> > the most logical path to take.
>>
>> Perhaps not surprisingly, I would prefer to get a chance to review a
>> major change to the core RDMA midlayer rather than having you merge it
>> through your tree.  So yes I do object.  Please give me a chance to
>> review and merge it.  I am working on that this week.
>>
>
> Great.  We'll be looking for a response by the end of the week.
>
> Otherwise if you end up not having time, we'd still like to move forward for v3.15 given the amount of review the series has already gotten on the list.
>
> Thank you,
>
> --nab
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
