From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH V2] powerpc/infiniband: Use cache inhibitted and guarded
 mapping on powerpc
Date: Wed, 20 Apr 2016 16:29:42 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25ACE29D@fmsmsx120.amr.corp.intel.com>
References: <1461139097-10213-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1461139097-10213-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Language: en-US
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "paulus@samba.org" <paulus@samba.org>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "Hefty,
 Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

PiBGcm9tOiBBbmVlc2ggS3VtYXIgSy5WIFttYWlsdG86YW5lZXNoLmt1bWFyQGxpbnV4LnZuZXQu
aWJtLmNvbV0KPiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDIwLCAyMDE2IDM6NTggQU0KPiBTdWJq
ZWN0OiBbUEFUQ0ggVjJdIHBvd2VycGMvaW5maW5pYmFuZDogVXNlIGNhY2hlIGluaGliaXR0ZWQg
YW5kIGd1YXJkZWQKPiBtYXBwaW5nIG9uIHBvd2VycGMKPiAKCkRvdWcsIGNhbiB5b3UgZml4IHVw
IHRoZSBzdW1tYXJ5IHRvIGdpdCB0aGUgc3BlbGxpbmcgZXJyb3IgYW5kIHBvd2VycGMvaW5maW5p
YmFuZDogIC0+IElCL3FpYjoKClRoYW5rcyBmb3IgdGhlIHBhdGNoIQoKQWNrZWQtYnk6IE1pa2Ug
TWFyY2luaXN6eW4gPG1pa2UubWFyY2luaXN6eW5AaW50ZWwuY29tPgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eHBwYy1kZXYgbWFpbGluZyBsaXN0
CkxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnCmh0dHBzOi8vbGlzdHMub3psYWJzLm9yZy9s
aXN0aW5mby9saW51eHBwYy1kZXY=
