From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Fri, 12 May 2017 18:24:35 +0000
Message-ID: <1494613473.14477.12.camel@sandisk.com>
References: <20170507064349.GM22833@mtr-leonro.local>
         <1494351789.3752.5.camel@profitbricks.com>
         <1494352472.2518.10.camel@sandisk.com>
         <20170509181807.GB9715@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="_002_14946134731447712camelsandiskcom_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509181807.GB9715-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_14946134731447712camelsandiskcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <D8C992E916FEFE40A444439677ECC613-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-05-09 at 12:18 -0600, Jason Gunthorpe wrote:
> On Tue, May 09, 2017 at 05:54:33PM +0000, Bart Van Assche wrote:
> > > *=A0Bonus points: consolidate the srp daemon. Debian ships a differen=
t
> > > service file than upstream, but I am against an additional layer
> > > introduced by srp_daemon.sh. It would also be nice to have a systemd
> > > service shipped by upstream (and not just in the redhat directory)
> >=20
> > I will have a look at this too.
>=20
> My thoughts..
>=20
> It looked to me like srp_daemon needed one process per port.
>=20
> The best path looked to me like using systemd templates (eg
> srp_daemon@mlx4_0/0) to allow systemd to directly manage the per port
> srp_daemon.
>=20
> Then the question is how to request the right templates are
> created.. Perhaps udev rules can do this directly, but I'm not sure
> about how to get the port #, perhaps an udev triggered script or
> something can do it.
>=20
> Perhaps there could be an inbetween progarm that took the udev events
> and asked systemd to make the right units.
>=20
> Another option is to have a srp_daemon 'runner' that monitors udev and
> actively manages a set of fork'd childern so that the children cover
> all required ports. But this is actually somewhat hard to do well..
>=20
> The big issue with the redhat script is that it is not hotplug safe,
> and needs special boot ordering, which we really need to get away from
> in general for robustness.

Hello Jason,

Thanks for having shared your thoughts.

When using systemd templates instead of the current approach it would
become cumbersome for users to stop and start the srp_daemon on all ports
simultaneously. Additionally, if an RDMA adapter is hot-added, should the
srp_daemon be started or should it not be started for the newly added ports=
?

An in-between program could indeed do the job of listening for udev events
and actively managing srp_daemon children. Since we already have an
in-between program, namely srp_daemon.sh, the simplest approach is to modif=
y
that shell script. Can you have a look at the attached patch?

Thanks,

Bart.=

--_002_14946134731447712camelsandiskcom_
Content-Type: text/x-patch;
	name="0001-srp_daemon.service-Add-support-for-hotplugging.patch"
Content-Description: 0001-srp_daemon.service-Add-support-for-hotplugging.patch
Content-Disposition: attachment;
	filename="0001-srp_daemon.service-Add-support-for-hotplugging.patch";
	size=2836; creation-date="Fri, 12 May 2017 18:24:34 GMT";
	modification-date="Fri, 12 May 2017 18:24:34 GMT"
Content-ID: <BE44DDEA0E831244BC3A5AAC9D5A8331-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Content-Transfer-Encoding: base64

RnJvbSBiZWMzODg0ZTM2Mjk4YWIyYjZmYjA5YzUzM2I1NzVmYTk1YmQzMzc4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHNhbmRp
c2suY29tPgpEYXRlOiBGcmksIDEyIE1heSAyMDE3IDEwOjI0OjQ0IC0wNzAwClN1YmplY3Q6IFtQ
QVRDSF0gc3JwX2RhZW1vbi5zZXJ2aWNlOiBBZGQgc3VwcG9ydCBmb3IgaG90cGx1Z2dpbmcKCklu
c3RlYWQgb2Ygb25seSBzdGFydGluZyBzcnBfZGFlbW9uLnNoIGFmdGVyIHRoZSBSRE1BIHN1YnN5
c3RlbSBoYXMKYmVlbiBpbml0aWFsaXplZCwgbWFrZSBzcnBfZGFlbW9uLnNoIHNjYW4gcGVyaW9k
aWNhbGx5IGZvciBSRE1BIHBvcnRzLgpBbiBhZHZhbnRhZ2Ugb2YgdGhlIG5ldyBhcHByb2FjaCBp
cyB0aGF0IGl0IHN1cHBvcnRzIGhvdC1hZGQgb2YgUkRNQQphZGFwdGVycy4KClNpZ25lZC1vZmYt
Ynk6IEJhcnQgVmFuIEFzc2NoZSA8YmFydC52YW5hc3NjaGVAc2FuZGlzay5jb20+Ci0tLQogcmVk
aGF0L3NycF9kYWVtb24uc2VydmljZSAgIHwgIDQgLS0tLQogc3JwX2RhZW1vbi9zcnBfZGFlbW9u
LnNoLmluIHwgNDEgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KIDIg
ZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgMTkgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvcmVkaGF0L3NycF9kYWVtb24uc2VydmljZSBiL3JlZGhhdC9zcnBfZGFlbW9uLnNlcnZp
Y2UKaW5kZXggOTUxMGY1ZmIuLmNmOThhYTc0IDEwMDY0NAotLS0gYS9yZWRoYXQvc3JwX2RhZW1v
bi5zZXJ2aWNlCisrKyBiL3JlZGhhdC9zcnBfZGFlbW9uLnNlcnZpY2UKQEAgLTMsMTAgKzMsNiBA
QCBEZXNjcmlwdGlvbj1TdGFydCBvciBzdG9wIHRoZSBkYWVtb24gdGhhdCBhdHRhY2hlcyB0byBT
UlAgZGV2aWNlcwogRG9jdW1lbnRhdGlvbj1tYW46c3JwX2RhZW1vbiBmaWxlOi9ldGMvcmRtYS9y
ZG1hLmNvbmYgZmlsZTovZXRjL3NycF9kYWVtb24uY29uZgogRGVmYXVsdERlcGVuZGVuY2llcz1m
YWxzZQogQ29uZmxpY3RzPWVtZXJnZW5jeS50YXJnZXQgZW1lcmdlbmN5LnNlcnZpY2UKLVJlcXVp
cmVzPXJkbWEuc2VydmljZQotV2FudHM9b3BlbnNtLnNlcnZpY2UKLUFmdGVyPXJkbWEuc2Vydmlj
ZSBvcGVuc20uc2VydmljZQotQWZ0ZXI9bmV0d29yay50YXJnZXQKIEJlZm9yZT1yZW1vdGUtZnMt
cHJlLnRhcmdldAogCiBbU2VydmljZV0KZGlmZiAtLWdpdCBhL3NycF9kYWVtb24vc3JwX2RhZW1v
bi5zaC5pbiBiL3NycF9kYWVtb24vc3JwX2RhZW1vbi5zaC5pbgppbmRleCA3NWU4YTMxYi4uNzRj
MDhkN2EgMTAwNzU1Ci0tLSBhL3NycF9kYWVtb24vc3JwX2RhZW1vbi5zaC5pbgorKysgYi9zcnBf
ZGFlbW9uL3NycF9kYWVtb24uc2guaW4KQEAgLTM3LDYgKzM3LDcgQEAgcmVzY2FuX2ludGVydmFs
PTYwCiBwaWRzPSgpCiBwaWRmaWxlPSJAQ01BS0VfSU5TVEFMTF9GVUxMX1JVTkRJUkAvc3JwX2Rh
ZW1vbi5zaC5waWQiCiBteXBpZD0kJAordW1hZF9kZXZzPSgpCiAKIHRyYXBfaGFuZGxlcigpCiB7
CkBAIC00OSw2ICs1MCwxNyBAQCB0cmFwX2hhbmRsZXIoKQogICAgIGV4aXQgMAogfQogCisjIENo
ZWNrIHdoZXRoZXIgJDEgaXMgZXF1YWwgdG8gb25lIG9mICQyLi4keyQjfQorY29udGFpbnMoKQor
eworICAgIGxvY2FsIHYKKworICAgIGZvciB2IGluICIke0A6Mn0iOyBkbworCVsgIiR2IiA9ICIk
MSIgXSAmJiByZXR1cm4gMAorICAgIGRvbmUKKyAgICByZXR1cm4gMQorfQorCiAjIENoZWNrIGlm
IHRoZXJlIGlzIGFub3RoZXIgY29weSBydW5uaW5nIG9mIHNycF9kYWVtb24uc2gKIGlmIFsgLWYg
IiRwaWRmaWxlIiBdOyB0aGVuCiAgICAgaWYgWyAtZSAiL3Byb2MvJChjYXQgIiRwaWRmaWxlIiAy
Pi9kZXYvbnVsbCkvc3RhdHVzIiBdOyB0aGVuCkBAIC02NiwxOSArNzgsMTggQEAgZmkKIAogdHJh
cCAndHJhcF9oYW5kbGVyJyAyIDE1CiAKLXdoaWxlIFsgISAtZCAke2liZGlyfSBdCi1kbwotICAg
IHNsZWVwIDMwCit3aGlsZSA6OyBkbworICAgIGZvciBkIGluICR7aWJkaXJ9X21hZC91bWFkKjsg
ZG8KKwlbIC1lICIkZCIgXSB8fCBjb250aW51ZQorCWNvbnRhaW5zICIkZCIgIiR7dW1hZF9kZXZz
W0BdfSIgJiYgY29udGludWUKKwloY2FfaWQ9IiQoPCIkZC9pYmRldiIpIgorCXBvcnQ9IiQoPCIk
ZC9wb3J0IikiCisJYWRkX3RhcmdldD0iJHtpYmRpcn1fc3JwL3NycC0ke2hjYV9pZH0tJHtwb3J0
fS9hZGRfdGFyZ2V0IgorCWlmIFsgLWUgIiR7YWRkX3RhcmdldH0iIF07IHRoZW4KKyAgICAgICAg
ICAgICR7cHJvZ30gLWUgLWMgLW4gLWkgIiR7aGNhX2lkfSIgLXAgIiR7cG9ydH0iIC1SICIke3Jl
c2Nhbl9pbnRlcnZhbH0iICIke3BhcmFtc1tAXX0iID4vZGV2L251bGwgMj4mMSAmCisgICAgICAg
ICAgICBwaWRzKz0oJCEpCisJICAgIHVtYWRfZGV2Kz0oJGQpCisJZmkKKyAgICBkb25lCisgICAg
c2xlZXAgJHJlc2Nhbl9pbnRlcnZhbAogZG9uZQotCi1mb3IgZCBpbiAke2liZGlyfV9tYWQvdW1h
ZCo7IGRvCi0gICAgaGNhX2lkPSIkKDwiJGQvaWJkZXYiKSIKLSAgICBwb3J0PSIkKDwiJGQvcG9y
dCIpIgotICAgIGFkZF90YXJnZXQ9IiR7aWJkaXJ9X3NycC9zcnAtJHtoY2FfaWR9LSR7cG9ydH0v
YWRkX3RhcmdldCIKLSAgICBpZiBbIC1lICIke2FkZF90YXJnZXR9IiBdOyB0aGVuCi0gICAgICAg
ICR7cHJvZ30gLWUgLWMgLW4gLWkgIiR7aGNhX2lkfSIgLXAgIiR7cG9ydH0iIC1SICIke3Jlc2Nh
bl9pbnRlcnZhbH0iICIke3BhcmFtc1tAXX0iID4vZGV2L251bGwgMj4mMSAmCi0gICAgICAgIHBp
ZHMrPSgkISkKLSAgICBmaQotZG9uZQotCi13YWl0Ci0tIAoyLjEyLjIKCg==

--_002_14946134731447712camelsandiskcom_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
