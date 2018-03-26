From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: RFC on writel and writel_relaxed
Date: Mon, 26 Mar 2018 11:08:45 +0000
Message-ID: <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
 <1521726722.16434.312.camel@kernel.crashing.org>
 <20180323163510.GC13033@ziepe.ca>
 <1521854626.16434.359.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1521854626.16434.359.camel@kernel.crashing.org>
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
To: 'Benjamin Herrenschmidt' <benh@kernel.crashing.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sinan Kaya <okaya@codeaurora.org>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT
 AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

PiA+IFRoaXMgaXMgYSBzdXBlciBwZXJmb3JtYW5jZSBjcml0aWNhbCBvcGVyYXRpb24gZm9yIG1v
c3QgZHJpdmVycyBhbmQNCj4gPiBkaXJlY3RseSBpbXBhY3RzIG5ldHdvcmsgcGVyZm9ybWFuY2Uu
DQoNClBlcmhhcHMgdGhlcmUgb3VnaHQgdG8gYmUgd3JpdGVsX25vYmFycmllcigpIChldGMpIHRo
YXQgbmV2ZXIgY29udGFpbg0KYW55IGJhcnJpZXJzIGF0IGFsbC4NClRoaXMgbWlnaHQgbWVhbiB0
aGF0IHRoZXkgYXJlIGFsd2F5cyBqdXN0IHRoZSBtZW1vcnkgb3BlcmF0aW9uLA0KYnV0IGl0IHdv
dWxkIG1ha2UgaXQgbW9yZSBvYnZpb3VzIHdoYXQgdGhlIGRyaXZlciB3YXMgZG9pbmcuDQoNClRo
ZSBkcml2ZXIgd291bGQgdGhlbiBiZSBleHBsaWNpdGx5IHJlc3BvbnNpYmxlIGZvciBhbGwgdGhl
IHJtYigpLCB3bWIoKQ0KYW5kIG1taW93YigpIChldGMpLg0KUGVyZm9ybWFuY2UgY3JpdGljYWwg
cGF0aHMgY291bGQgdGhlbiBhdm9pZCBhbGwgdGhlIGV4dHJhIGJhcnJpZXJzLg0KDQoJRGF2aWQN
Cg0KDQo=
