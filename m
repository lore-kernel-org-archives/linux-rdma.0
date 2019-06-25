From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [RFC][PATCH] wake_up_var() memory ordering
Date: Tue, 25 Jun 2019 14:12:22 +0200
Message-ID: <CAHc6FU6zUCdQZ1AfN2KYcPYVKc5bwvc0bD7=-KZpFXws+F9QZQ@mail.gmail.com>
References: <20190624165012.GH3436@hirez.programming.kicks-ass.net>
 <CAHc6FU7j5iW7WQoxN_OSfvK4zxv_MxTWJpiNsqFW8TEDMX1rjw@mail.gmail.com>
 <20190625103430.GW3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20190625103430.GW3402@hirez.programming.kicks-ass.net>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Brandenburg <martin@omnibond.com>, linux-cachefs@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-aio@kvack.org, David Airlie <airlied@linux.ie>, samba-technical <samba-technical@lists.samba.org>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, keyrings@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, linux-afs@lists.infradead.org, Alasdair Kergon <agk@redhat.com>, Mike Marshall <hubcap@omnibond.com>, linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, James Morris <jmorris@namei.org>, cluster-devel <cluster-devel@redhat.com>, Antti Palosaari <crope@iki.fi>, Matthias Brugger <matthias.bgg@gmail.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, intel-gfx@lists.freedesktop.org, devel@lists.orangefs.org, "Serge E. Hallyn" <serge@ha>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyNSBKdW4gMjAxOSBhdCAxMjozNiwgUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZy
YWRlYWQub3JnPiB3cm90ZToKPiBPbiBUdWUsIEp1biAyNSwgMjAxOSBhdCAxMToxOTozNUFNICsw
MjAwLCBBbmRyZWFzIEdydWVuYmFjaGVyIHdyb3RlOgo+ID4gPiBkaWZmIC0tZ2l0IGEvZnMvZ2Zz
Mi9nbG9wcy5jIGIvZnMvZ2ZzMi9nbG9wcy5jCj4gPiA+IGluZGV4IGNmNGM3NjcwMDViMS4uNjY2
NjI5ZWE1ZGE3IDEwMDY0NAo+ID4gPiAtLS0gYS9mcy9nZnMyL2dsb3BzLmMKPiA+ID4gKysrIGIv
ZnMvZ2ZzMi9nbG9wcy5jCj4gPiA+IEBAIC0yMjcsNiArMjI3LDcgQEAgc3RhdGljIHZvaWQgZ2Zz
Ml9jbGVhcl9nbG9wX3BlbmRpbmcoc3RydWN0IGdmczJfaW5vZGUgKmlwKQo+ID4gPiAgICAgICAg
ICAgICAgICAgcmV0dXJuOwo+ID4gPgo+ID4gPiAgICAgICAgIGNsZWFyX2JpdF91bmxvY2soR0lG
X0dMT1BfUEVORElORywgJmlwLT5pX2ZsYWdzKTsKPiA+ID4gKyAgICAgICBzbXBfbWJfX2FmdGVy
X2F0b21pYygpOwo+ID4gPiAgICAgICAgIHdha2VfdXBfYml0KCZpcC0+aV9mbGFncywgR0lGX0dM
T1BfUEVORElORyk7Cj4gPgo+ID4gVGhpcyBzaG91bGQgYmVjb21lIGNsZWFyX2FuZF93YWtlX3Vw
X2JpdCBhcyB3ZWxsLCByaWdodD8gVGhlcmUgYXJlCj4gPiBzZXZlcmFsIG1vcmUgaW5zdGFuY2Vz
IG9mIHRoZSBzYW1lIHBhdHRlcm4uCj4KPiBPbmx5IGlmIHdlIGRvIGFzIERhdmlkIHN1Z2dlc3Rl
ZCBhbmQgbWFrZSBjbGVhbl9hbmRfd2FrZV91cF9iaXQoKQo+IHByb3ZpZGUgdGhlIFJFTEVBU0Ug
YmFycmllci4KCihJdCdzIGNsZWFyX2FuZF93YWtlX3VwX2JpdCwgbm90IGNsZWFuX2FuZF93YWtl
X3VwX2JpdC4pCgo+IFRoYXQgaXMsIGN1cnJlbnRseSBjbGVhcl9hbmRfd2FrZV91cF9iaXQoKSBp
cwo+Cj4gICAgICAgICBjbGVhcl9iaXQoKQo+ICAgICAgICAgc21wX21iX19hZnRlcl9hdG9taWMo
KTsKPiAgICAgICAgIHdha2VfdXBfYml0KCk7Cj4KPiBCdXQgdGhlIGFib3ZlIGlzOgo+Cj4gICAg
ICAgICBjbGVhcl9iaXRfdW5sb2NrKCk7Cj4gICAgICAgICBzbXBfbWJfX2FmdGVyX2F0b21pYygp
Owo+ICAgICAgICAgd2FrZV91cF9iaXQoKQo+Cj4gdGhlIGRpZmZlcmVuY2UgaXMgdGhhdCBfdW5s
b2NrKCkgdXNlcyBSRUxFQVNFIHNlbWFudGljcywgd2hlcmUKPiBjbGVhcl9iaXQoKSBkb2VzIG5v
dC4KPgo+IFRoZSBkaWZmZXJlbmNlIGlzIGlsbHVzdHJhdGVkIHdpdGggc29tZXRoaW5nIGxpa2U6
Cj4KPiAgICAgICAgIGNvbmQgPSB0cnVlOwo+ICAgICAgICAgY2xlYXJfYml0KCkKPiAgICAgICAg
IHNtcF9tYl9fYWZ0ZXJfYXRvbWljKCk7Cj4gICAgICAgICB3YWtlX3VwX2JpdCgpOwo+Cj4gSW4g
dGhpcyBjYXNlLCBhIHJlbW90ZSBDUFUgY2FuIGZpcnN0IG9ic2VydmUgdGhlIGNsZWFyX2JpdCgp
IGFuZCB0aGVuCj4gdGhlICdjb25kID0gdHJ1ZScgc3RvcmUuIFdoZW4gd2UgdXNlIGNsZWFyX2Jp
dF91bmxvY2soKSB0aGlzIGlzIG5vdAo+IHBvc3NpYmxlLCBiZWNhdXNlIHRoZSBSRUxFQVNFIGJh
cnJpZXIgZW5zdXJlcyB0aGF0IGV2ZXJ5dGhpbmcgYmVmb3JlLAo+IHN0YXlzIGJlZm9yZS4KCk5v
dyBJJ20gY29uZnVzZWQgYmVjYXVzZSBjbGVhcl9hbmRfd2FrZV91cF9iaXQoKSBpbiBtYWlubGlu
ZSBkb2VzIHVzZQpjbGVhcl9iaXRfdW5sb2NrKCksIHNvIGl0J3MgdGhlIGV4YWN0IG9wcG9zaXRl
IG9mIHdoYXQgeW91IGp1c3Qgc2FpZC4KClRoYW5rcywKQW5kcmVhcwpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0Cklu
dGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
