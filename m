From: Amir Ancel <amira-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: CQ overrun with ib_send_bw
Date: Tue, 17 Aug 2010 22:08:44 +0300
Message-ID: <1EEC75D0B27041449A1EEA2927D1B145380145AAAB@MTLMAIL.mtl.com>
References: <4C659288.4030402@oracle.com>
	<1281726396.2313.44.camel@chromite.mv.qlogic.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25A96887A2@orsmsx501.amr.corp.intel.com>
	<1281727297.2313.47.camel@chromite.mv.qlogic.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443B5668DE17@MTLMAIL.mtl.com>
	<1EEC75D0B27041449A1EEA2927D1B145380145A7DA@MTLMAIL.mtl.com>
	<1282071547.2313.100.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282071547.2313.100.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raz Baussi <razb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks,

We'll apply it soon.

Amir Ancel
Performance Team Manager
Mellanox Technologies


-----Original Message-----
From: Ralph Campbell [mailto:ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org] 
Sent: Tuesday, August 17, 2010 9:59 PM
To: Amir Ancel
Cc: Tziporet Koren; Hefty, Sean; Ido Shamay; Sumeet Lahorani; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Raz Baussi
Subject: RE: CQ overrun with ib_send_bw

The patch is attached.

On Tue, 2010-08-17 at 04:36 -0700, Amir Ancel wrote:
> Hi Sean,
> 
> We've seen this issue as well.
> 
> Can you send the patch directly to us ?
> 
> Added Raz from my team which replaces Ido while he is OOO.
> 
> 
> Thanks,
> 
> Amir Ancel
> Performance Team Manager
> Mellanox Technologies
> 
> -----Original Message-----
> From: Tziporet Koren
> Sent: Tuesday, August 17, 2010 2:19 PM
> To: Ralph Campbell; Hefty, Sean; Ido Shamay; Amir Ancel
> Cc: Sumeet Lahorani; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: CQ overrun with ib_send_bw
> 
> On 8/13/2010 10:21 PM, Ralph Campbell wrote:
> > On Fri, 2010-08-13 at 12:14 -0700, Hefty, Sean wrote:
> >>> I know there is a bug with "ib_send_bw -b" (bi-directional) since 
> >>> it doesn't create a CQ that is large enough for all the posted 
> >>> sends *and* receives.  I have tried several times to get the 
> >>> following patch applied but I never got a reply and nothing was 
> >>> done.
> >>
> >> Who's the maintainer of these tests?
> >
> > I believe it is:
> >
> > Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> >
> > git://git.openfabrics.org/~shamoya/perftest.git
> >
> >
> 
> Yes Ido is the maintainer, however he is on vacation till Sep.
> I add Amir that may help for now
> 
> Tziporet
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
