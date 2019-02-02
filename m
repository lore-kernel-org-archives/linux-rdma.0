From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC net-next 11/13] nfp: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri, 1 Feb 2019 20:22:33 -0800
Message-ID: <53b9c429-9bf2-926d-1727-5833ad5eb732@gmail.com>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
 <20190201220657.30170-12-f.fainelli@gmail.com>
 <20190201194541.49754fbf@cakuba.hsd1.ca.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190201194541.49754fbf@cakuba.hsd1.ca.comcast.net>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Jakub Kicinski <jakub.kicinski@netronome.com>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, John Hurley <john.hurley@netronome.com>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, "Francois H. Theron" <francois.theron@netronome.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Ivan Vecera <ivecera@redhat.com>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Vivien Didelot <vivien.didelot@gmail.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, Daniel Borkmann <daniel@iogearbox.net>, Simon Horman <simon.horman@netronome.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Edwin Peer <edwin.peer@netronome.com>, Michael Chan <michael.chan@broadcom.com>, Derek Chickles <dchi>
List-Id: linux-rdma@vger.kernel.org

TGUgMi8xLzE5IMOgIDc6NDUgUE0sIEpha3ViIEtpY2luc2tpIGEgw6ljcml0wqA6Cj4gT24gRnJp
LCAgMSBGZWIgMjAxOSAxNDowNjo1NSAtMDgwMCwgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToKPj4g
Rm9sbG93aW5nIHBhdGNoZXMgd2lsbCBjaGFuZ2UgdGhlIHdheSB3ZSBjb21tdW5pY2F0ZSBnZXR0
aW5nIG9yIHNldHRpbmcKPj4gYSBwb3J0J3MgYXR0cmlidXRlIGFuZCB1c2UgYSBibG9ja2luZyBu
b3RpZmllciB0byBwZXJmb3JtIHRob3NlIHRhc2tzLgo+Pgo+PiBQcmVwYXJlIG5mcCB0byBzdXBw
b3J0IHJlY2VpdmluZyBub3RpZmllciBldmVudHMgdGFyZ2V0aW5nCj4+IFNXSVRDSERFVl9QT1JU
X0FUVFJfR0VUIGFuZCBzaW1wbHkgdHJhbnNsYXRlIHRoYXQgaW50byB0aGUgZXhpc3RpbmcKPj4g
c3dpdGNoZGV2X29wczo6c3dpdGNoZGV2X3BvcnRfYXR0cl9nZXQgb3BlcmF0aW9uLgo+Pgo+PiBX
ZSByZWdpc3RlciBhIHNpbmdsZSBibG9ja2luZyBzd2l0Y2hkZXYgbm90aWZpZXIgZm9yIHRoZSBl
bnRpcmUgZHJpdmVyCj4+IGluc3RhbmNlIGFuZCB3ZSBkaWZmZXJlbnRpYXRlIGEgIm5ldCIgZnJv
bSBhICJyZXByIiBieSBjb21wYXJpbmcgdGhlCj4+IG5ldHdvcmsgZGV2aWNlJ3MgbmV0ZGV2X29w
cyB3aXRoIHRoZSBvbmVzIHRoYXQgdGhpcyBkcml2ZXIgbWFuYWdlcy4KPj4KPj4gU2lnbmVkLW9m
Zi1ieTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+Cj4gCj4gVGhhbmtz
IEZsb3JpYW4sIHRoZSBjb2RlIGxvb2tzIGdvb2QsIG9ubHkgbml0IEkgaGF2ZSBpcyAtIGNvdWxk
IHlvdQo+IG1vdmUgbmZwX3N3aXRjaGRldl9ibG9ja2luZ19ldmVudCgpIHRvIG5mcF9wb3J0LmMg
YW5kIG5mcF9wb3J0Lmg/Cj4gV2Ugc2hvdWxkbid0IHRvdWNoIG5mcF9uZXRfY29tbW9uLmMgaGVy
ZS4KClNvdW5kcyBnb29kLCB0aGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLgoKPiAKPiBJbiBnZW5l
cmFsIGNhbGxpbmcgYSBub3RpZmllciB0byBnZXQgdGhlIHBhcmVudF9pZCAod2hpY2ggaXMgdGhl
IG9ubHkKPiB0aGluZyBhbGwgdGhlc2UgU1ItSU9WIE5JQyBkcml2ZXJzIGltcGxlbWVudCkgc2Vl
bXMgYSB0YWQgaGVhdnkuICBJdCdzCj4gYW4gaW1tdXRhYmxlLCByZWFkLW9ubHkgYXR0cmlidXRl
IG9mIGEgcG9ydCwgcGVyaGFwcyB3ZSBjYW4gYnJlYWsgaXQKPiBvdXQ/ICBDb3VsZCB3ZSBtYWtl
IGl0IGFuIE5ETywgcGVyaGFwcz8KCkEgTkRPIHdvdWxkIGJlIGZpbmUgd2l0aCBtZSwgSWRvLCB3
aGF0IGRvIHlvdSB0aGluaz8KCj4gCj4gVGhhdCdzIGp1c3QgbXkga25lZSBqZXJrIHJlYWN0aW9u
LCBnaXZlbiB0aGF0IE5JQyBkcml2ZXJzIGRvbid0Cj4gaW1wbGVtZW50IGFueSBvZiB0aGUgYnJp
ZGdpbmcgc2lkZSBvZiBzd2l0Y2hkZXYgSSBtYXkgbm90IGhhdmUgYSBmdWxsCj4gYXBwcmVjaWF0
aW9uIG9mIHRoZSBhYnN0cmFjdGlvbiB5b3UgYXJlIGJ1aWxkaW5nIGhlcmUgOikKPiAKCklkbyBj
b252aW5jZWQgbWUgdG8gY29udmVydCB0aGUgc3dpdGNoZGV2X3BvcnRfYXR0cl9zZXQoKSBpbnRv
IGEKYmxvY2tpbmcgbm90aWZpZXIgc3VjaCB0aGF0IHdlIGNvdWxkIHZldG8gb3BlcmF0aW9ucyBp
biBzd2l0Y2ggZHJpdmVycywKb25jZSB5b3UgZG8gdGhhdCwgbGVhdmluZyB0aGUgZ2V0dGVyIGFz
IHN3aXRjaGRldl9vcHMgYmVjYW1lIHBvaW50bGVzcwo6KSBidXQgeWVzLCBpdCdzIGEgbG90IG9m
IGNvZGUganVzdCB0byBnZXQgdGhlcmUuCi0tIApGbG9yaWFuCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmRldmVsIG1haWxpbmcgbGlzdApkZXZlbEBsaW51
eGRyaXZlcnByb2plY3Qub3JnCmh0dHA6Ly9kcml2ZXJkZXYubGludXhkcml2ZXJwcm9qZWN0Lm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2RyaXZlcmRldi1kZXZlbAo=
