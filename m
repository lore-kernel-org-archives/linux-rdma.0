From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 hmm 04/12] mm/hmm: Simplify hmm_get_or_create and make
 it reliable
Date: Mon, 17 Jun 2019 21:36:58 -0300
Message-ID: <20190618003658.GC30762@ziepe.ca>
References: <20190614004450.20252-1-jgg@ziepe.ca>
 <20190614004450.20252-5-jgg@ziepe.ca>
 <20190615141211.GD17724@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190615141211.GD17724@infradead.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Philip Yang <Philip.Yang@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Jerome Glisse <jglisse@redhat.com>, amd-gfx@lists.freedesktop.org, Ira Weiny <ira.weiny@intel.com>, Ben Skeggs <bskeggs@redhat.com>
List-Id: linux-rdma@vger.kernel.org

T24gU2F0LCBKdW4gMTUsIDIwMTkgYXQgMDc6MTI6MTFBTSAtMDcwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6Cj4gPiArCXNwaW5fbG9jaygmbW0tPnBhZ2VfdGFibGVfbG9jayk7Cj4gPiArCWlm
IChtbS0+aG1tKSB7Cj4gPiArCQlpZiAoa3JlZl9nZXRfdW5sZXNzX3plcm8oJm1tLT5obW0tPmty
ZWYpKSB7Cj4gPiArCQkJc3Bpbl91bmxvY2soJm1tLT5wYWdlX3RhYmxlX2xvY2spOwo+ID4gKwkJ
CXJldHVybiBtbS0+aG1tOwo+ID4gKwkJfQo+ID4gKwl9Cj4gPiArCXNwaW5fdW5sb2NrKCZtbS0+
cGFnZV90YWJsZV9sb2NrKTsKPiAKPiBUaGlzIGNvdWxkIGJlY29tZToKPiAKPiAJc3Bpbl9sb2Nr
KCZtbS0+cGFnZV90YWJsZV9sb2NrKTsKPiAJaG1tID0gbW0tPmhtbQo+IAlpZiAoaG1tICYmIGty
ZWZfZ2V0X3VubGVzc196ZXJvKCZobW0tPmtyZWYpKQo+IAkJZ290byBvdXRfdW5sb2NrOwo+IAlz
cGluX3VubG9jaygmbW0tPnBhZ2VfdGFibGVfbG9jayk7Cj4gCj4gYXMgdGhlIGxhc3QgdHdvIGxp
bmVzIG9mIHRoZSBmdW5jdGlvbiBhbHJlYWR5IGRyb3AgdGhlIHBhZ2VfdGFibGVfbG9jawo+IGFu
ZCB0aGVuIHJldHVybiBobW0uICBPciBkcm9wIHRoZSAiaG1tID0gbW0tPmhtbSIgYXNpZ25tZW50
IGFib3ZlIGFuZAo+IHJldHVybiBtbS0+aG1tIGFzIHRoYXQgc2hvdWxkIGJlIGFsd2F5cyBpZGVu
dGljYWwgdG8gaG1tIGF0IHRoZSBlbmQKPiB0byBzYXZlIGFub3RoZXIgbGluZS4KClllYWgsIEkg
Y2FuIGZ1c3MgaXQgc29tZSBtb3JlLgoKPiA+ICsJLyoKPiA+ICsJICogVGhlIG1tLT5obW0gcG9p
bnRlciBpcyBrZXB0IHZhbGlkIHdoaWxlIG5vdGlmaWVyIG9wcyBjYW4gYmUgcnVubmluZwo+ID4g
KwkgKiBzbyB0aGV5IGRvbid0IGhhdmUgdG8gZGVhbCB3aXRoIGEgTlVMTCBtbS0+aG1tIHZhbHVl
Cj4gPiArCSAqLwo+IAo+IFRoZSBjb21tZW50IGNvbmZ1c2VzIG1lLiAgSG93IGRvZXMgdGhlIHBh
Z2VfdGFibGVfbG9jayByZWxhdGUgdG8KPiBwb3NzaWJseSBydW5uaW5nIG5vdGlmaWVycywgYXMg
SSBjYW4ndCBmaW5kIHRoYXQgd2UgdGFrZQo+IHBhZ2VfdGFibGVfbG9jaz8gIE9yIGlzIGl0IGp1
c3QgYWJvdXQgdGhlIGZhY3QgdGhhdCB3ZSBvbmx5IGNsZWFyCj4gbW0tPmhtbSBpbiB0aGUgZnJl
ZSBjYWxsYmFjaywgYW5kIG5vdCBpbiBobW1fZnJlZT8KCkl0IHdhcyBsYXRlIHdoZW4gSSB3cm90
ZSB0aGlzIGZpeHVwLCB0aGUgY29tbWVudCBpcyBmYXVsdHksIGFuZCB0aGVyZQppcyBubyByZWFz
b24gdG8gZGVsYXkgdGhpcyB1bnRpbCB0aGUgU1JDVSBjbGVhbnVwIGF0IHRoaXMgcG9pbnQgaW4g
dGhlCnNlcmllcy4KClRoZSBvcHMgYWxsIGdldCB0aGVpciBzdHJ1Y3QgaG1tIGZyb20gY29udGFp
bmVyX29mLCB0aGUgb25seSB0aGluZwp0aGF0IHJlZmVycyB0byBtbS0+aG1tIGlzIGhtbV9nZXRf
b3JfY3JlYXRlKCkuCgpJJ2xsIHJldmlzZSBpdCB0b21vcnJvdywgdGhlIGNvbW1lbnQgd2lsbCBn
byBhd2F5IGFuZCB0aGUgPU5VTEwgd2lsbApnbyB0byB0aGUgcmVsZWFzZSBjYWxsYmFjawoKSmFz
b24KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRl
dmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8v
bGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
