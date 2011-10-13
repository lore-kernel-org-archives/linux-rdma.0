From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Thu, 13 Oct 2011 11:35:04 -0700
Message-ID: <CAL1RGDXsgcC_99RFgPcgUW9GveMSykt_JTCcY-JMuAMF7JcnfQ@mail.gmail.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
 <20111011173929.GH26965@obsidianresearch.com> <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A98C@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW_usQ8o4FJzZqkmoZAvSTHBLZJuJ_YpsHL-=ErbgSw-A@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A9C0@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6AD2E@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXw=NK4TWvvf-gx7Fs1K3iC7yY-DAOZ8pmnni7oRaO=Ww@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237316E6AD8D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6AD8D-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2011 at 11:32 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
> I'm confused now. =A0The patch definitely looks like it's missing a c=
hange to uverbs_main.c to setup the command table. =A0(I thought you we=
re referring to needing a change to struct ib_device before.)

Right, we need to add it to the command table, and also the hardware dr=
iver
needs to opt into the function in its uverbs cmd mask.  (Even if the ca=
ll never
hits the hardware driver ... we could clean that up maybe, but I'm just=
 talking
about how things work at the moment)

> I'm looking at the code on my test system and trying to understand wh=
at exactly is happening. =A0The OFED compatibility should call this rou=
tine and care if it fails, and it looks like mpi cares too, but I don't=
 see how it can work... =A0Give me some time to look into this

No problem.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
