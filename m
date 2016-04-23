From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH V2] powerpc/infiniband: Use cache inhibitted and guarded
 mapping on powerpc
Date: Sat, 23 Apr 2016 18:25:49 +1000
Message-ID: <1461399949.3135.52.camel@kernel.crashing.org>
References: <1461139097-10213-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1461278876.3135.18.camel@kernel.crashing.org>
 <20160422160927.GB12897@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20160422160927.GB12897@obsidianresearch.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, paulus@samba.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Sean Hefty <sean.hefty@intel.com>, linuxppc-dev@lists.ozlabs.org, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyMDE2LTA0LTIyIGF0IDEwOjA5IC0wNjAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
Cj4gT24gRnJpLCBBcHIgMjIsIDIwMTYgYXQgMDg6NDc6NTZBTSArMTAwMCwgQmVuamFtaW4gSGVy
cmVuc2NobWlkdAo+IHdyb3RlOgo+ID4gCj4gPiBPbiBXZWQsIDIwMTYtMDQtMjAgYXQgMDM6NTgg
LTA0MDAsIEFuZWVzaCBLdW1hciBLLlYgd3JvdGU6Cj4gPiA+IAo+ID4gPiBUaGUgZHJpdmVyIHdh
cyByZXF1ZXN0aW5nIGZvciBhIHdyaXRldGhyb3VnaCBtYXBwaW5nLiBCdXQgd2l0aAo+ID4gPiB0
aG9zZXMKPiA+ID4gZmxhZ3Mgd2Ugd2lsbCBlbmQgdXAgd2l0aCBhIFNBTyBtYXBwaW5nIGJlY2F1
c2Ugd2Ugbm93IGhhdmUKPiA+ID4gbWVtb3J5Cj4gPiA+IGNvbmhlcmVuY2UgYWx3YXlzIGVuYWJs
ZWQuIGllLCB0aGUgZXhpc3RpbmcgbWFwcGluZyB3aWxsIGVuZCB1cAo+ID4gPiB3aXRoCj4gPiA+
IGEgV0lNRyB2YWx1ZSAwYjExMTAgd2hpY2ggaXMgU3Ryb25nIEFjY2VzcyBPcmRlci4KPiA+ID4g
Cj4gPiA+IFVwZGF0ZSB0aGlzIHRvIHVzZSBjYWNoZSBpbmhpYml0dGVkIGd1YXJkZWQgbWFwcGlu
Zwo+ID4gV2h5IGd1YXJkZWQgPyBJZiBpdCdzIHBlcmZvcm1hbmNlIHNlbnNpdGl2ZSAoYW5kIHRo
ZSBkcml2ZXIgaGFzCj4gPiBhcHByb3ByaWF0ZSBiYXJyaWVycyB3aGVyZSBuZWVkZWQpLCB5b3Ug
d2lsbCBnZXQgd3JpdGUgY29tYmluaW5nCj4gPiB3aXRob3V0IGd1YXJkZWQsIHlvdSB3b24ndCB3
aXRoIGl0Lgo+IFRoaXMgZHJpdmVyIHVzZXMgdW5jYWNoZWQgd3JpdGUgY29tYmluaW5nIG9uIHg4
NgoKUmlnaHQgc28gaWYgeW91IHdhbnQgc29tZXRoaW5nIHNpbWlsYXIgb24gcG93ZXIsIHVzZSB0
aGUgX3djIHZhcmlhbnQsCmFuZCBtYWtlIHN1cmUgeW91IGhhdmUgdGhlIGFwcHJvcHJpYXRlIGJh
cnJpZXJzIHdoZW4geW91IG5lZWQgdG8KYnJlYWsgY29tYmluaW5nLgoKQ2hlZXJzLApCZW4uCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eHBwYy1k
ZXYgbWFpbGluZyBsaXN0CkxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnCmh0dHBzOi8vbGlz
dHMub3psYWJzLm9yZy9saXN0aW5mby9saW51eHBwYy1kZXY=
