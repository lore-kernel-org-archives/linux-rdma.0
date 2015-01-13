From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 FIX for-3.19] IB/ipoib: Fix broken multicast flow
Date: Tue, 13 Jan 2015 16:01:00 -0500
Message-ID: <1421182860.43839.214.camel@redhat.com>
References: <1420643066-3599-1-git-send-email-ogerlitz@mellanox.com>
	 <CAJ3xEMh60SGsK43b49MSozqmL8PDzTevs5CMGCvhPfmL3kHHVQ@mail.gmail.com>
	 <1421167544.43839.190.camel@redhat.com>
	 <CAJ3xEMgJ_+b1avw6vacagSw0bxNVzLW064rztvJ6w3Y9Th0GRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-U0Grz3J/tS3PMqYO0wIA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgJ_+b1avw6vacagSw0bxNVzLW064rztvJ6w3Y9Th0GRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-U0Grz3J/tS3PMqYO0wIA
Content-Type: multipart/mixed; boundary="=-0TbpH9TgXhteuE4LhfY4"


--=-0TbpH9TgXhteuE4LhfY4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-01-13 at 22:13 +0200, Or Gerlitz wrote:
> On Tue, Jan 13, 2015 at 6:45 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> > On Fri, 2015-01-09 at 10:32 +0200, Or Gerlitz wrote:
> >> On Wed, Jan 7, 2015 at 5:04 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
> >> > From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >
> >> > Following commit 016d9fb25cd9 "IPoIB: fix MCAST_FLAG_BUSY usage"
> >> > both IPv6 traffic and for the most cases all IPv4 multicast traffic
> >> > aren't working.
> >>
> >> Doug, can you ack the breakage introduced by your commit and the fix?
> >
> > I haven't double checked the breakage, I'll take your word for it
>=20
> just try ping6 or iperf multicast and see it for yourself, please.

I have.  I have them working now.

>=20
> > (at the time I did my work, I had multicast debugging on and I verified=
 the
> > join/leave process, but I had assumed that the process would work the
> > same for optional multicast groups as it does for the IPoIB broadcast
> > group and other default IPoIB groups, so I didn't specifically test
> > additional multicast groups above and beyond the broadcast/etc groups).
> >
> > However, the fix is not workable.  In particular, as soon as this patch
> > is added to the kernel, you will start getting messages like this:
> >
> > mlx4_ib0: ipoib_mcast_leave on an in-flight join
>=20
>=20
> I don't see it on my systems, is that upstream you're running? what entit=
y does
> ,;x4_ib0: prefixed prints and under what settings, is that the IPoIB driv=
er?

No, that's my internal rhel7 tree, but it's so close to bare upstream
when it comes to IPoIB that there really shouldn't be any difference.
And mlx4_ib0 is just the name that I renamed ib0 to (An internal
standard in my test cluster is that all ib interfaces are named based
upon the hardware they are tied to, so mlx4_ib0, mlx5_ib0, qib_ib0, etc.
Makes my life in verifying code coverage easier)  I can test again with
an upstream kernel later today.  But, for now, suffice it to say the
problem is not resolved with the patch in this thread, but with the much
simpler patch I've attached to this email (note, this is made against
rhel7, I'm only attaching it so you can try it yourself, assuming it
even applies, and once I've tested it on an upstream kernel myself and
verified that it works properly, I'll submit the final upstream version
under a new thread).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-0TbpH9TgXhteuE4LhfY4
Content-Disposition: attachment; filename="ipoib-mcast-test.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="ipoib-mcast-test.patch"; charset="UTF-8"

Y29tbWl0IGRjMmM3MTg5NmVkYzNiNTQ5ZTc5YTUxY2Y4M2RiODEzZDYwMTJhMzQKQXV0aG9yOiBE
b3VnIExlZGZvcmQgPGRsZWRmb3JkQHJlZGhhdC5jb20+CkRhdGU6ICAgVHVlIEphbiAxMyAxMzoz
NTo0MCAyMDE1IC0wNTAwCgogICAgSUIvaXBvaWI6IEZpeCBmYWlsZWQgbXVsdGljYXN0IGpvaW5z
L3NlbmRzCiAgICAKICAgIFRoZSB1c2FnZSBvZiBJUE9JQl9NQ0FTVF9SVU4gYXMgYSBmbGFnIGlz
IGluY29uc2lzdGVudC4gIEluIHNvbWUgcGxhY2VzCiAgICBpdCBpcyB1c2VkIHRvIG1lYW4gIm91
ciBkZXZpY2UgaXMgYWRtaW5pc3RyYXRpdmVseSBhbGxvd2VkIHRvIHNlbmQKICAgIG11bHRpY2Fz
dCBqb2lucy9sZWF2ZXMvcGFja2V0cyIgYW5kIGluIG90aGVyIHBsYWNlcyBpdCBtZWFucyAib3Vy
CiAgICBtdWx0aWNhc3Qgam9pbiB0YXNrIHRocmVhZCBpcyBjdXJyZW50bHkgcnVubmluZyBhbmQg
d2lsbCBwcm9jZXNzIHlvdXIKICAgIHJlcXVlc3QgaWYgeW91IHB1dCBpdCBvbiB0aGUgcXVldWUi
LiAgSG93ZXZlciwgdGhpcyBsYXR0ZXIgbWVhbmluZyBpcyBpbgogICAgZmFjdCBmbGF3ZWQgYXMg
dGhlcmUgaXMgYSByYWNlIGNvbmRpdGlvbiBiZXR3ZWVuIHRoZSBqb2luIHRhc2sgdGVzdGluZwog
ICAgdGhlIG1jYXN0IGxpc3QgYW5kIGZpbmRpbmcgaXQgZW1wdHkgb2YgcmVtYWluaW5nIHdvcmss
IGRyb3BwaW5nIHRoZQogICAgbWNhc3QgbXV0ZXggYW5kIGFsc28gdGhlIHByaXYtPmxvY2sgc3Bp
bmxvY2ssIGFuZCBjbGVhcmluZyB0aGUKICAgIElQT0lCX01DQVNUX1JVTiBmbGFnLiAgRnVydGhl
ciwgdGhlcmUgYXJlIG51bWVyb3VzIGxvY2F0aW9ucyB0aGF0IHVzZQogICAgdGhlIGZsYWcgaW4g
dGhlIGZvcm1lciBmYXNoaW9uLCBhbmQgd2hlbiBhbGwgdGFza3MgY29tcGxldGUgYW5kIHRoZSB0
YXNrCiAgICB0aHJlYWQgY2xlYXJzIHRoZSBSVU4gZmxhZywgYWxsIG9mIHRob3NlIG90aGVyIGxv
Y2F0aW9ucyB3aWxsIGZhaWwgdG8KICAgIGV2ZXIgYWdhaW4gcXVldWUgYW55IHdvcmsuICBUaGlz
IHJlc3VsdHMgaW4gdGhlIGludGVyZmFjZSBjb21pbmcgdXAgZmluZQogICAgaW5pdGlhbGx5LCBi
dXQgaGF2aW5nIHByb2JsZW1zIGFkZGluZyBuZXcgbXVsdGljYXN0IGdyb3VwcyBhZnRlciB0aGUK
ICAgIGZpcnN0IHJvdW5kIG9mIGdyb3VwcyBoYXZlIGFsbCBiZWVuIGFkZGVkIGFuZCB0aGUgUlVO
IGZsYWcgaXMgY2xlYXJlZCBieQogICAgdGhlIGpvaW4gdGFzayB0aHJlYWQgd2hlbiBpdCB0aGlu
a3MgaXQgaXMgZG9uZS4gIFRvIHJlc29sdmUgdGhpcyBpc3N1ZSwKICAgIGNvbnZlcnQgYWxsIGxv
Y2F0aW9ucyBpbiB0aGUgY29kZSB0byB0cmVhdCB0aGUgUlVOIGZsYWcgYXMgYW4gaW5kaWNhdG9y
CiAgICB0aGF0IHRoZSBtdWx0aWNhc3QgcG9ydGlvbiBvZiB0aGlzIGludGVyZmFjZSBpcyBpbiBm
YWN0IGFkbWluaXN0cmF0aXZlbHkKICAgIHVwIGFuZCBqb2lucy9sZWF2ZXMvc2VuZHMgY2FuIGJl
IHBlcmZvcm1lZC4gIFRoZXJlIGlzIG5vIGhhcm0gKG90aGVyCiAgICB0aGFuIGEgc2xpZ2h0IHBl
cmZvcm1hbmNlIHBlbmFsdHkpIHRvIG5ldmVyIGNsZWFyaW5nIHRoaXMgZmxhZyBhbmQgdXNpbmcK
ICAgIGl0IGluIHRoaXMgZmFzaGlvbiBhcyBpdCBzaW1wbHkgbWVhbnMgdGhhdCBhIGZldyBwbGFj
ZXMgdGhhdCB1c2VkIHRvCiAgICBtaWNyby1vcHRpbWl6ZSBob3cgb2Z0ZW4gdGhpcyB0YXNrIHdh
cyBxdWV1ZWQgb24gYSB3b3JrIHF1ZXVlIHdpbGwgbm93CiAgICBxdWV1ZSB0aGUgdGFzayBhIGZl
dyBleHRyYSB0aW1lcy4gIFdlIGNhbiBhZGRyZXNzIHRoYXQgc3Vib3B0aW1hbAogICAgYmVoYXZp
b3IgaW4gZnV0dXJlIHBhdGNoZXMuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IERvdWcgTGVkZm9y
ZCA8ZGxlZGZvcmRAcmVkaGF0LmNvbT4KCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQv
dWxwL2lwb2liL2lwb2liX211bHRpY2FzdC5jIGIvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pcG9p
Yi9pcG9pYl9tdWx0aWNhc3QuYwppbmRleCA4YTUzOGMwMTBiOS4uY2JhNmUxNjBkZjIgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC91bHAvaXBvaWIvaXBvaWJfbXVsdGljYXN0LmMKKysr
IGIvZHJpdmVycy9pbmZpbmliYW5kL3VscC9pcG9pYi9pcG9pYl9tdWx0aWNhc3QuYwpAQCAtNjM4
LDggKzYzOCw2IEBAIHZvaWQgaXBvaWJfbWNhc3Rfam9pbl90YXNrKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykKIAl9CiAKIAlpcG9pYl9kYmdfbWNhc3QocHJpdiwgInN1Y2Nlc3NmdWxseSBqb2lu
ZWQgYWxsIG11bHRpY2FzdCBncm91cHNcbiIpOwotCi0JY2xlYXJfYml0KElQT0lCX01DQVNUX1JV
TiwgJnByaXYtPmZsYWdzKTsKIH0KIAogaW50IGlwb2liX21jYXN0X3N0YXJ0X3RocmVhZChzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2KQpAQCAtNjQ5LDggKzY0Nyw4IEBAIGludCBpcG9pYl9tY2FzdF9z
dGFydF90aHJlYWQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIAlpcG9pYl9kYmdfbWNhc3QocHJp
diwgInN0YXJ0aW5nIG11bHRpY2FzdCB0aHJlYWRcbiIpOwogCiAJbXV0ZXhfbG9jaygmbWNhc3Rf
bXV0ZXgpOwotCWlmICghdGVzdF9hbmRfc2V0X2JpdChJUE9JQl9NQ0FTVF9SVU4sICZwcml2LT5m
bGFncykpCi0JCXF1ZXVlX2RlbGF5ZWRfd29yayhwcml2LT53cSwgJnByaXYtPm1jYXN0X3Rhc2ss
IDApOworCXNldF9iaXQoSVBPSUJfTUNBU1RfUlVOLCAmcHJpdi0+ZmxhZ3MpOworCXF1ZXVlX2Rl
bGF5ZWRfd29yayhwcml2LT53cSwgJnByaXYtPm1jYXN0X3Rhc2ssIDApOwogCW11dGV4X3VubG9j
aygmbWNhc3RfbXV0ZXgpOwogCiAJcmV0dXJuIDA7CkBAIC03MzMsNyArNzMxLDcgQEAgdm9pZCBp
cG9pYl9tY2FzdF9zZW5kKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHU4ICpkYWRkciwgc3RydWN0
IHNrX2J1ZmYgKnNrYikKIAkJbWVtY3B5KG1jYXN0LT5tY21lbWJlci5tZ2lkLnJhdywgbWdpZCwg
c2l6ZW9mICh1bmlvbiBpYl9naWQpKTsKIAkJX19pcG9pYl9tY2FzdF9hZGQoZGV2LCBtY2FzdCk7
CiAJCWxpc3RfYWRkX3RhaWwoJm1jYXN0LT5saXN0LCAmcHJpdi0+bXVsdGljYXN0X2xpc3QpOwot
CQlpZiAoIXRlc3RfYW5kX3NldF9iaXQoSVBPSUJfTUNBU1RfUlVOLCAmcHJpdi0+ZmxhZ3MpKQor
CQlpZiAodGVzdF9iaXQoSVBPSUJfTUNBU1RfUlVOLCAmcHJpdi0+ZmxhZ3MpKQogCQkJcXVldWVf
ZGVsYXllZF93b3JrKHByaXYtPndxLCAmcHJpdi0+bWNhc3RfdGFzaywgMCk7CiAJfQogCkBAIC05
NTksNyArOTU3LDggQEAgdm9pZCBpcG9pYl9tY2FzdF9yZXN0YXJ0X3Rhc2soc3RydWN0IHdvcmtf
c3RydWN0ICp3b3JrKQogCS8qCiAJICogUmVzdGFydCBvdXIgam9pbiB0YXNrIGlmIG5lZWRlZAog
CSAqLwotCWlwb2liX21jYXN0X3N0YXJ0X3RocmVhZChkZXYpOworCWlmICh0ZXN0X2JpdChJUE9J
Ql9NQ0FTVF9SVU4sICZwcml2LT5mbGFncykpCisJCXF1ZXVlX2RlbGF5ZWRfd29yayhwcml2LT53
cSwgJnByaXYtPm1jYXN0X3Rhc2ssIDApOwogCXJ0bmxfdW5sb2NrKCk7CiB9CiAK


--=-0TbpH9TgXhteuE4LhfY4--

--=-U0Grz3J/tS3PMqYO0wIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUtYeNAAoJELgmozMOVy/dESIP/07CV72EjFij4t9+gybewiXq
YvKNAAHzo7cvdsxaK8Atdup0s8qD5KX8YUjtv2eu+6swkEYxpmWZ1L26xRkNkcmm
bcyKfjXwT2Nl95Hu07eVOMWD/oqM2Ym5mOnNmBTIekJJ5wGyEfH5kLz2Lpkzb1gc
sSuImkek03XpvyFoNG/i9GNXNovVHx2795ji+erCrP8NZOp/nr34IYG3asuaWGbo
tFLYkIxfmaTh9EUFsUZHHkbDX16yL0N1CIMuEg48UcePnL7nW9CvkEXzzptBwuUT
kaEEkwkzUkZJED3hSYV9+6VteAhL9LKzPRrV7kXJfv9pN01Ij3Eb8Bh3HfALiaqQ
CpD4O1ZMqr3/k1JqEjVQjGCsh6RUsFr3/eUEIUwLvNHP+TD/AkRfqjYRP2QC+xX8
G0BZozXYBukBUisJELpflGEBEYRwAt6SyFbc3g0ECFzwLMMlWk0v69OZwox37A/O
Y+CrY70MZPIW1uFtI1HSSIV+RuJjkcuBVjttbzM979hwVYE6YCmixas4gNU6LgVm
GdiQbC06iXLcmu5ypX07cSZpWewT7bdrWoRUr3Z39lYoOWBjdxuEOKARO+BM/0RZ
oPCa2l6aM8XMYbUcekbE9810MB2PNXwM7TzA4OQJJSlZTNU7YCXNvQJFdaIJPYfU
gGGh1vG2FJDGdbjMZdjQ
=163I
-----END PGP SIGNATURE-----

--=-U0Grz3J/tS3PMqYO0wIA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
