From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Thu, 26 May 2016 19:39:34 +0300
Message-ID: <20160526163934.GU25500@leon.nu>
References: <1A4F4C32-CE5A-44D9-9BFE-0E1F8D5DF44D@oracle.com>
 <57238F8C.70505@sandisk.com>
 <B72A389F-FFF1-498C-A946-8AA72B7769F8@oracle.com>
 <57277B63.8030506@sandisk.com>
 <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com>
 <1AFD636B-09FC-4736-B1C5-D1D9FA0B97B0@oracle.com>
 <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1PHmS26pdpOR3Xc0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8a3276bf-f716-3dca-9d54-369fc3bdcc39-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1PHmS26pdpOR3Xc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2016 at 07:24:29PM +0300, Yishai Hadas wrote:
> On 5/25/2016 6:58 PM, Chuck Lever wrote:
> >Hello Yishai-
> >
> >Reporting an mlx4 IB driver bug below. Sorry for the
> >length.
> >
> >
> >>On May 3, 2016, at 10:57 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >>
> >>>On May 2, 2016, at 12:08 PM, Bart Van Assche <bart.vanassche@sandisk.c=
om> wrote:
> >>>
> >>>On 05/02/2016 08:10 AM, Chuck Lever wrote:
> >>>>>On Apr 29, 2016, at 12:45 PM, Bart Van Assche <bart.vanassche@sandis=
k.com> wrote:
> >>>>>On 04/29/2016 09:24 AM, Chuck Lever wrote:
> >>>>>>I've found some new behavior, recently, while testing the
> >>>>>>v4.6-rc Linux NFS/RDMA client and server.
> >>>>>>
> >>>>>>When certain kernel memory debugging CONFIG options are
> >>>>>>enabled, 1MB NFS WRITEs can sometimes result in a
> >>>>>>IB_WC_LOC_PROT_ERR. I usually turn on most of them because
> >>>>>>I want to see any problems, so I'm not sure which option
> >>>>>>in particular is exposing the issue.
> >>>>>>
> >>>>>>When debugging is enabled on the server, and the underlying
> >>>>>>device is using FRWR to register the sink buffer, an RDMA
> >>>>>>Read occasionally completes with LOC_PROT_ERR.
> >>>>>>
> >>>>>>When debugging is enabled on the client, and the underlying
> >>>>>>device uses FRWR to register the target of an RDMA Read, an
> >>>>>>ingress RDMA Read request sometimes gets a Syndrome 99
> >>>>>>(REM_OP_ERR) acknowledgement, and a subsequent RDMA Receive
> >>>>>>on the client completes with LOC_PROT_ERR.
> >>>>>>
> >>>>>>I do not see this problem when kernel memory debugging is
> >>>>>>disabled, or when the client is using FMR, or when the
> >>>>>>server is using physical addresses to post its RDMA Read WRs,
> >>>>>>or when wsize is 512KB or smaller.
> >>>>>>
> >>>>>>I have not found any obvious problems with the client logic
> >>>>>>that registers NFS WRITE buffers, nor the server logic that
> >>>>>>constructs and posts RDMA Read WRs.
> >>>>>>
> >>>>>>My next step is to bisect. But first, I was wondering if
> >>>>>>this behavior might be related to the recent problems with
> >>>>>>s/g lists seen with iSER/SRP? ie, is this a recognized
> >>>>>>issue?
> >>>>>
> >>>>>Hello Chuck,
> >>>>>
> >>>>>A few days ago I observed similar behavior with the SRP protocol but=
 only if I increase max_sect in /etc/srp_daemon.conf from the default to 40=
96. My setup was as follows:
> >>>>>* Kernel 4.6.0-rc5 at the initiator side.
> >>>>>* A whole bunch of kernel debugging options enabled at the initiator
> >>>>>side.
> >>>>>* The following settings in /etc/modprobe.d/ib_srp.conf:
> >>>>>options ib_srp cmd_sg_entries=3D255 register_always=3D1
> >>>>>* The following settings in /etc/srp_daemon.conf:
> >>>>>a queue_size=3D128,max_cmd_per_lun=3D128,max_sect=3D4096
> >>>>>* Kernel 3.0.101 at the target side.
> >>>>>* Kernel debugging disabled at the target side.
> >>>>>* mlx4 driver at both sides.
> >>>>>
> >>>>>Decreasing max_sge at the target side from 32 to 16 did not help. I =
have not yet had the time to analyze this further.
> >>>>
> >>>>git bisect result:
> >>>>
> >>>>d86bd1bece6fc41d59253002db5441fe960a37f6 is the first bad commit
> >>>>commit d86bd1bece6fc41d59253002db5441fe960a37f6
> >>>>Author: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
> >>>>Date:   Tue Mar 15 14:55:12 2016 -0700
> >>>>
> >>>>   mm/slub: support left redzone
> >>>>
> >>>>I checked out the previous commit and was not able to
> >>>>reproduce, which gives some confidence that the bisect
> >>>>result is valid.
> >>>>
> >>>>I've also investigated the wire behavior a little more.
> >>>>The server I'm using for testing has FRWR artificially
> >>>>disabled, so it uses physical addresses for RDMA Read.
> >>>>This limits it to max_sge_rd, or 30 pages for each Read
> >>>>request.
> >>>>
> >>>>The client sends a single 1MB Read chunk. The server
> >>>>emits 8 30-page Read requests, and a ninth request for
> >>>>the last 16 pages in the chunk.
> >>>>
> >>>>The client's HCA responds to the 30-page Read requests
> >>>>properly. But on the last Read request, it responds
> >>>>with a Read First, 14 Read Middle responses, then an
> >>>>ACK with Syndrome 99 (Remote Operation Error).
> >>>>
> >>>>This suggests the last page in the memory region is
> >>>>not accessible to the HCA.
> >>>>
> >>>>This does not happen on the first NFS WRITE, but
> >>>>rather one or two subsequent NFS WRITEs during the test.
> >>>
> >>>On an x86 system that patch changes the alignment of buffers > 8 bytes=
 from 16 bytes to 8 bytes (ARCH_SLAB_MINALIGN / ARCH_KMALLOC_MINALIGN). The=
re might be code in the mlx4 driver that makes incorrect assumptions about =
the alignment of memory allocated by kmalloc(). Can someone from Mellanox c=
omment on the alignment requirements of the buffers allocated by mlx4_buf_a=
lloc()?
> >>>
> >>>Thanks,
> >>>
> >>>Bart.
> >>
> >>Let's also bring this to the attention of the patch's author.
> >>
> >>Joonsoo, any ideas about how to track this down? There have
> >>been several reports on linux-rdma of unexplained issues when
> >>SLUB debugging is enabled.
> >
> >Joonsoo and I tracked this down.
> >
> >The original problem report was Read and Receive WRs
> >completing with Local Protection Error when SLUB
> >debugging was enabled.
> >
> >We found that the problem occurred only when debugging
> >was enabled for the kmalloc-4096 slab.
> >
> >A kmalloc tracepoint log shows one likely mlx4 call
> >site that uses the kmalloc-4096 slab with NFS.
> >
> >kworker/u25:0-10565 [005]  5300.132063: kmalloc:              (mlx4_ib_a=
lloc_mr+0xb8) [FAILED TO PARSE] call_site=3D0xffffffffa0294048 ptr=3D0xffff=
88043d808008     bytes_req=3D2112 bytes_alloc=3D4432 gfp_flags=3D37781696
> >
> >So let's look at mlx4_ib_alloc_mr().
> >
> >The call to kzalloc() at the top of this function is for
> >size 136, so that's not the one in this trace log entry.
> >
> >However, later in mlx4_alloc_priv_pages(), there is
> >a kzalloc of the right size. NFS will call ib_alloc_mr
> >with just over 256 sg's, which gives us a 2112 byte
> >allocation request.
> >
> >I added some pr_err() calls in this function to have
> >a look at the addresses returned by kmalloc.
> >
> >When debugging is disabled, kzalloc returns page-aligned
> >addresses:
>=20
> Is it defined some where that regular kzalloc/kmalloc guaranties to retur=
n a
> page-aligned address as you see in your testing ? if so the debug mode
> should behave the same. Otherwise we can consider using any flag allocati=
on
> that can force that if such exists.
> Let's get other people's input here.

No, kmalloc()/kzalloc() doesn't guarantee alignment. You should use
get_free_pages() for page-aligned allocations.

--1PHmS26pdpOR3Xc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJXRybGAAoJEORje4g2clinLrkP+J5sMUvfaX9zbJ8khnhaSHBh
DAChkOS+dvVPhDnQKyZgmRogm8+fthtyhEAFyRn8jElTLy44Zf+Jh/qIBIqgEerM
Lipj1+iJzWOORTNsvR/XMvHFOLUGl89YbFvONOc3HxLQt0/FwYs1BMExJ5u9/gCE
qi2viLBmssjU3XHoMbCu3a5ENzSCoI3m7k6uI276aZqaviEYdF5btDwgcG03A60f
N4XsIa7DG7TLkWHbVT6sPQsGBG9+uThy5cyyRwg+8Y50SI3+ElazVGJvKAJQ9dlM
2DkObytZmINxBTD4BA5L+kRLZBj5ZrMWT3S9zRjOpvmnA5QUIe5UoV/6L5D4mr62
wFmMBGeWi/VPaw/3NqRNY56NilCtCP6zzU4/+rtJ1kQmwoUnj0YjL2jB5HZJS5aq
Za8RWFWzdn2jS9ljcrtpu34Txw8ApdUy/i+dYeYM+sCpamptSV4SpZHcGBcB7Nb/
eeAFL91AbqkY/c0ynCkQMte0Z/2bkeISZFTpnjdj7y25XwY0v0ykmaNxzbI2N31k
vnmOgai4zDilMBWjPTuaQQCB9nEt1jnt2tQl3+yOEHdyq4MZP8axEY/AbyYxeth4
nMNMaOGTSF76B2k+q1OTx+lkaPFKNbTRyFMpueNJVbm/58o9w8B0iPVIB0W/vKu7
Kij+pWNQL54bR2D+mDI=
=cfQ3
-----END PGP SIGNATURE-----

--1PHmS26pdpOR3Xc0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
