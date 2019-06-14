From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/16] staging/comedi: mark as broken
Date: Fri, 14 Jun 2019 17:34:28 +0200
Message-ID: <20190614153428.GA10008@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
 <20190614134726.3827-13-hch@lst.de> <20190614140239.GA7234@kroah.com>
 <20190614144857.GA9088@lst.de> <20190614153032.GD18049@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190614153032.GD18049@kroah.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-media@vger.kernel.org, Intel Linux Wireless <linuxwifi@intel.com>, intel-gfx@lists.freedesktop.org, Ian Abbott <abbotti@mev.co.uk>, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, H Hartley Sweeten <hsweeten@visionengravers.com>, iommu@lists.linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBKdW4gMTQsIDIwMTkgYXQgMDU6MzA6MzJQTSArMDIwMCwgR3JlZyBLSCB3cm90ZToK
PiBPbiBGcmksIEp1biAxNCwgMjAxOSBhdCAwNDo0ODo1N1BNICswMjAwLCBDaHJpc3RvcGggSGVs
bHdpZyB3cm90ZToKPiA+IE9uIEZyaSwgSnVuIDE0LCAyMDE5IGF0IDA0OjAyOjM5UE0gKzAyMDAs
IEdyZWcgS0ggd3JvdGU6Cj4gPiA+IFBlcmhhcHMgYSBoaW50IGFzIHRvIGhvdyB3ZSBjYW4gZml4
IHRoaXMgdXA/ICBUaGlzIGlzIHRoZSBmaXJzdCB0aW1lCj4gPiA+IEkndmUgaGVhcmQgb2YgdGhl
IGNvbWVkaSBjb2RlIG5vdCBoYW5kbGluZyBkbWEgcHJvcGVybHkuCj4gPiAKPiA+IEl0IGNhbiBi
ZSBmaXhlZCBieToKPiA+IAo+ID4gIGEpIG5ldmVyIGNhbGxpbmcgdmlydF90b19wYWdlIChvciB2
bWFsbG9jX3RvX3BhZ2UgZm9yIHRoYXQgbWF0dGVyKQo+ID4gICAgIG9uIGRtYSBhbGxvY2F0aW9u
Cj4gPiAgYikgbmV2ZXIgcmVtYXBwaW5nIGRtYSBhbGxvY2F0aW9uIHdpdGggY29uZmxpY3Rpbmcg
Y2FjaGUgbW9kZXMKPiA+ICAgICAobm8gcmVtYXBwaW5nIHNob3VsZCBiZSBkb2FibGUgYWZ0ZXIg
YSkgYW55d2F5KS4KPiAKPiBPaywgZmFpciBlbm91Z2gsIGhhdmUgYW55IHBvaW50ZXJzIG9mIGRy
aXZlcnMvY29yZSBjb2RlIHRoYXQgZG9lcyB0aGlzCj4gY29ycmVjdGx5PyAgSSBjYW4gcHV0IGl0
IG9uIG15IHRvZG8gbGlzdCwgYnV0IG1pZ2h0IHRha2UgYSB3ZWVrIG9yIHNvLi4uCgpKdXN0IGFi
b3V0IGV2ZXJ5b25lIGVsc2UuICBUaGV5IGp1c3QgbmVlZCB0byByZW1vdmUgdGhlIHZtYXAgYW5k
CmVpdGhlciBkbyBvbmUgbGFyZ2UgYWxsb2NhdGlvbiwgb3IgbGl2ZSB3aXRoIHRoZSBmYWN0IHRo
YXQgdGhleSBuZWVkCmhlbHBlcnMgdG8gYWNjZXNzIG11bHRpcGxlIGFycmF5IGVsZW1lbnRzIGlu
c3RlYWQgb2Ygb25lIG5ldCB2bWFwLAp3aGljaCBtb3N0IG9mIHRoZSB1c2VycyBhbHJlYWR5IHNl
ZW0gdG8gZG8gYW55d2F5LCB3aXRoIGp1c3QgYSBmZXcKdXNpbmcgdGhlIHZtYXAgKHdoaWNoIG1p
Z2h0IGV4cGxhaW4gd2h5IHdlIGRpZG4ndCBzZWUgYmxvd3VwcyB5ZXQpLgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0
CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3Rv
cC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
