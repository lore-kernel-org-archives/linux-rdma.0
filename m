From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Thu, 30 Jul 2015 17:42:16 -0400
Message-ID: <55BA9A38.2030401@redhat.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nfSl7e77qWA60TRaEAURtxB0BgWelLVx1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC25777DA0-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nfSl7e77qWA60TRaEAURtxB0BgWelLVx1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/30/2015 04:01 PM, Marciniszyn, Mike wrote:
>>
>> I thought you were getting rid of this?
>>
>> Jason
>=20
> Doug wanted the v4 submitted as we currently have it.

To be accurate, I said "If you want a chance at making 4.3, I need a
v4".  I didn't comment on whether or not any specific review comments
were addressed.

> Doug?

I have no problem with this code.  That Al finds the user space ABI for
this driver to be bizarre is neither here nor there to me.  Sure, this
file does not exhibit normal file API behavior.  Who cares?  It's not a
normal file in *any* sense of the word.  For example, the normal write
routine will never, ever accept just plain data.  It's always in the
form of a command.  If you don't have the right magic decoder ring, you
will get nothing but errors when trying to do something with this file.
 Much like /dev/infiniband/uverbs? files, it is a command interface, not
a raw data interface.  I actually think the fact that you guys use write
for a single command and writev/write_iter for a command queue is an
elegant solution to your particular needs.  The only reason Al threw a
hissy over it is because it tripped him up when he went to do the
conversion from writev to write_iter.  That's understandable.  So, some
clear documentation so someone like Al doesn't have to go reading
through sources and try to figure out what you are doing would be the
generally nice thing to do for other kernel generalists that might come
poking around this way.  Or, another option would be to drop the write
function altogether and just make all commands come through
writev/write_iter and if you only have one command, you only send one
element.  Regardless, those things can be cleaned up in follow on
patches, please do not resubmit this set for that.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nfSl7e77qWA60TRaEAURtxB0BgWelLVx1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVupo4AAoJELgmozMOVy/dgnsP/ieYGm2LSkhIGYQYxuS8fEaz
ku+XUZO7wwj9QKRrm3ctr8Vm7wnwKmChRsg4RpbXfmGb1jQ8ge3ZUO5nD9MmxRll
toRTDPUQG3CZYgwhoHu3L5rdPi554hM1n+19zxtn9fMZFeyumGebUiyrL6bBzKJy
McNJ2oqv3K4o3HbJi3klgIVp4qhQYDSPKP5Qtj0FefgmEJYClcscc8it3FgpJQ4d
4DzbcGGrZBh+a8KIiiZxPlXtghPE/EY0hYz5hNa363ohYaDeHK4fP2DkCyPxbOvq
mdBZi38a9SIEuxqoN3s3aDHWnOEV+RHsxqCxMrbY+f1M/TsO0zy5eVii2/ye7fKb
CktyNiMyW0FhWfbg0b94O3uTZwXVNRopUvwBxc3kWS+yxf8qEnPhaIAvCaDT2ylg
A42AyREnLSUqoiDMOIvkm4pGJmjkJXW/z01eKD34RYgyPb68P3IyqItfAgcWAAXT
mGuE+NCXxIS8+CGbcBi9WxeFi0DispKIuWV4Dixy/0R3sqbQVdybb/n3QfWybgsl
X6HlE25ykeJjXFSMLpyGYFr6pqswFKhZusCPmgJoLVWDhJpqFTPUvfVTjZ7H4XqO
hHvVJlLPL2vh1P65SR1Xegsx/xhkFM0IklCOazcLk4Lh1JiulT22SJAmfeMDtOMT
ZM9EAAUoXybkcsAhZtrB
=iQIy
-----END PGP SIGNATURE-----

--nfSl7e77qWA60TRaEAURtxB0BgWelLVx1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
