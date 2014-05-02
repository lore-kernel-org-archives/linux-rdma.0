From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 00/17] NFS/RDMA client-side patches
Date: Fri, 2 May 2014 16:20:41 -0400
Message-ID: <45067B04-660C-4971-B12F-AEC9F7D32785@oracle.com>
References: <20140430191433.5663.16217.stgit@manet.1015granger.net> <5363f223.e39f420a.4af6.6fc9SMTPIN_ADDED_BROKEN@mx.google.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5363f223.e39f420a.4af6.6fc9SMTPIN_ADDED_BROKEN-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Allen Andrews <allen.andrews-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 2, 2014, at 3:27 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> ----- Original Message -----
>> Changes since V2:
>>=20
>> - Rebased on v3.15-rc3
>>=20
>> - "enable pad optimization" dropped. Testing showed Linux NFS/RDMA
>>   server does not support pad optimization yet.
>>=20
>> - "ALLPHYSICAL CONFIG" dropped. There is a lack of consensus on
>>   this one. Christoph would like ALLPHYSICAL removed, but the HPC
>>   community prefers keeping a performance-at-all-costs option. And,
>>   with most other registration modes now removed, ALLPHYSICAL is
>>   the mode of last resort if an adapter does not support FRMR or
>>   MTHCAFMR, since ALLPHYSICAL is universally supported. We will
>>   very likely revisit this later. I'm erring on the side of less
>>   churn and dropping this until the community agrees on how to
>>   move forward.
>>=20
>> - Added a patch to ensure there is always a valid ->qp if RPCs
>>   might awaken while the transport is disconnected.
>>=20
>> - Added a patch to clean up an MTU settings hack for a very old
>>   adapter model.
>>=20
>> Test and review the "nfs-rdma-client" branch:
>>=20
>> git://git.linux-nfs.org/projects/cel/cel-2.6.git
>>=20
>> Thanks!
>=20
> Hi Chuck,
>=20
> I've installed this in my cluster and ran a number of simple tests
> over a variety of hardware.  For the most part, it's looking much
> better than NFSoRDMA looked a kernel or two back, but I can still
> trip it up.  All tests were run with rhel7 + current upstream
> kernel.
>=20
> My server was using mlx4 hardware in both IB and RoCE modes.
>=20
> I tested from mlx4 client in both IB and RoCE modes -> not DOA
> I tested from mlx5 client in IB mode -> not DOA
> I tested from mthca client in IB mode -> not DOA
> I tested from qib client in IB mode -> not DOA
> I tested from ocrdma client in RoCE mode -> DOA (cpu soft lockup
>  on mount on the client)
>=20
> I tested nfsv3 -> not DOA
> I tested nfsv4 + rdma -> still DOA, but I think this is expected
>  as last I knew someone needs to write code for nfsv4 mountd
>  over rdma before this will work (as nfsv3 uses a tcp connection
>  to do mounting, and then switches to rdma for data transfers
>  and nfsv4 doesn't support that or something like that...this
>  is what I recall Jeff Layton telling me anyway)
>=20
> I tested nfsv3 in both IB and RoCE modes with rsize=3D32768 and
> wsize=3D32768 -> not DOA, reliable, did data verification and passed
>=20
> I tested nfsv3 in both IB and RoCE modes with rsize=3D65536 and
> wsize=3D65536 -> not DOA, but not reliable either, data transfers
> will stop after a certain amount has been transferred and the
> mount will have a soft hang

Can you clarify what you mean by =93soft hang?=94 Are you seeing a
problem when mounting with the =93soft=94 mount option, or does this
mean =93CPU soft lockup?=94 (INFO: task hung for 120 seconds)

> My data verification was simple (but generally effective in
> lots of scenarios):
>=20
> I had a full linux kernel git repo, with a complete build in it
> (totaling a little over 9GB of disk space used) and I would run
> tar -cf - linus | tar -xvf - -C <tmpdir> to copy the tree
> around (I did copies both on the same mount and on a different
> mount that was also NFSoRDMA, including copying from an IB
> NFSoRDMA mount to a RoCE NFSoRDMA mount on different mlx4 ports),
> and then diff -uprN on the various tree locations to check for
> any data differences.
>=20
> So there's your testing report.  As I said in the beginning, it's
> definitely better than it was since it used to oops the server and
> I didn't encounter any server side problems this time, only client
> side problems.

Thanks for testing!

> ToDo items that I see:
>=20
> Write NFSv4 rdma protocol mount support

NFSv4 does not use the MNT protocol. If NFSv4 is not working for you,
there=92s something else going on. For me NFSv4 works as well as NFSv3.
Let me know if you need help troubleshooting.

> Fix client soft mount hangs when rsize/wsize > 32768

Does that problem occur with unpatched v3.15-rc3 on the client?

HCAs/RNICs that support MTHCAFMR and FRMR should be working up to the
largest rsize and wsize supported by the client and server.

When I use ALLPHYSICAL with large wsize, typically the server starts
dropping NFS WRITE requests. The client retries them forever, and that
looks like a mount point hang.

Something like https://bugzilla.linux-nfs.org/show_bug.cgi?id=3D248

> Fix DOA of ocrdma driver

Does that problem occur with unpatched v3.15-rc3 on the client?

Emulex has reported some problems when reconnecting, but
I haven=92t heard of issues that occur right at mount time.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
