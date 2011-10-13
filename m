From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Thu, 13 Oct 2011 11:06:24 -0700
Message-ID: <CAL1RGDXw=NK4TWvvf-gx7Fs1K3iC7yY-DAOZ8pmnni7oRaO=Ww@mail.gmail.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
 <20111011173929.GH26965@obsidianresearch.com> <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A98C@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW_usQ8o4FJzZqkmoZAvSTHBLZJuJ_YpsHL-=ErbgSw-A@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A9C0@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237316E6AD2E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E6AD2E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2011 at 10:31 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
> ib_open_qp() is implemented entirely in the verbs layer (verbs.c). =A0=
The OFED API compatibility support that I added to libibverbs makes use=
 of this call, which I tested by running OSU's mvapich2.

Wait, now I'm baffled by the patch (ie
http://git.openfabrics.org/git?p=3D~shefty/rdma-dev.git;a=3Dcommitdiff;=
h=3D1ec4e62a6e967ddc258e7c4e674168debb727d39)

I don't see anything that calls ib_uverbs_open_qp().  Am I missing some=
thing??

Does the OFED API compatibility actually call this function and care
if it fails?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
