From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Wed, 16 Sep 2015 11:21:21 -0400
Message-ID: <55F988F1.8000508@redhat.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
 <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com>
 <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com> <20150915191159.GB24173@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nB95axbb8OrElxWTNaS3K3I2w0pS8DneU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150915191159.GB24173-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nB95axbb8OrElxWTNaS3K3I2w0pS8DneU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/15/2015 03:11 PM, Jason Gunthorpe wrote:
> On Tue, Sep 15, 2015 at 02:24:21PM -0400, Doug Ledford wrote:
>=20
>> suggesting.  What's more, there are a few difficulties here in that I'=
m
>> fairly certain the core networking layer doesn't have the concept of a=

>> send-only join, yet we would need it to have such.
>=20
> The mcast list in the core is soley for listing subscriptions for
> inbound - ie receive.

Agreed.

> Abusing it for send-side is probably the wrong
> direction overall.

I wouldn't "abuse" it for such, I would suggest adding a proper notion
of send-only registrations.

> send-side addressing is always done with the neighbour table. If core
> net infrastructure is to be done here it makes alot more sense to
> store multicast IP's in the neighbour table and drive the join
> lifetime from that side.

Wherever the right place in the core would turn out to be, my point was
that we should talk to netdev about extending the core multicast code to
have a notion of IPoIB's need for send-only groups to be tracked, then
set a flag on the device that notes it needs tracked, and have the core
code track these subscriptions.  I would then modify the ipoib multicast
code so that the join/leave handler could deal with both sendonly and
full joins/leaves, scrap the auto send-only join in mcast_send, and
modify mcast_restart_task to be able to promote/demote joins based upon
changes in the core maintained join list.  That would be my preferred
way to handle this.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nB95axbb8OrElxWTNaS3K3I2w0pS8DneU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+YjxAAoJELgmozMOVy/dUg0QAIIoxVMWFJfolkEP4iiMt5xA
XPZzVuiNNS6wwIJydV74Kuu90x3dkyfaReY6WlVBI6hW03NF5oVttZJwdorII1vj
PC1g5BDQLlWKV9s0xWvI10KZLYgITpqL4YwygmwiufGZ4BOFez+7aSC0ikSK63tb
FpgUcbH6PNuRarhxIf1RM3bEWVEpCPw5CL2M41PhGufQffN3/YEtEJyQjkc57jNi
brHjALBUwQvikw1gcy5neic+LZrn1JdN4Yn+GKOA+eqffXBx8OJHnNAhs5Z2vPb5
/wBsGJe3JwFFURudJqtMlp2y1fVkr6nS9c0jJ8dqBqk/01qOJMKckPCmkMYuRBSk
BhWk+cHNwqAyqKa8sNOeoQo5hQ8PqOLb/YyDsv6lFivGREmbzJyXjyM5G5bMLH4O
r8pwehicUC+AC7ELoX9emaslSUBbvmWFoa+p+u9RC9EbneRlupTXPjYTeJfuw4cH
3idIvNJO5MhjODtxLGkBro70CEHK3Yq6ZJ29lna7yRF9l/hL2i9lNofEsjC6lt7d
G6qYITopCq5ILZGJ7yCwqbNPimArYlHn609FbpIKdl6IFWLNG84acE2uyiwhIm/j
dt6C1KWNOrh9NQPRv1hBIMb2TsWerNok2xRsX5paQ4a4R7xoEgbHnG8yjJ54P8T5
AkH7G9NYTub6GWpM9wn7
=Secn
-----END PGP SIGNATURE-----

--nB95axbb8OrElxWTNaS3K3I2w0pS8DneU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
