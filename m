From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v1 iproute2-next 2/3] rdma: print driver resource attributes
Date: Tue, 15 May 2018 12:51:16 -0500
Message-ID: <01ee01d3ec75$52feb7b0$f8fc2710$@opengridcomputing.com>
References: <cover.1525709213.git.swise@opengridcomputing.com> <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com> <20180513132447.GF10381@mtr-leonro.mtl.com> <c57b8f18-858c-62df-50c6-453933a67913@opengridcomputing.com> <13da78012c55e8f224c2226f3c0cfc53bd0522be.camel@redhat.com> <20180515165955.GD10381@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180515165955.GD10381@mtr-leonro.mtl.com>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, May 15, 2018 at 12:35:34PM -0400, Doug Ledford wrote:
> > On Mon, 2018-05-14 at 09:51 -0500, Steve Wise wrote:
> > >
> > > On 5/13/2018 8:24 AM, Leon Romanovsky wrote:
> > > > On Mon, May 07, 2018 at 08:53:16AM -0700, Steve Wise wrote:
> > > > > This enhancement allows printing rdma device-specific state, if
> provided
> > > > > by the kernel.  This is done in a generic manner, so rdma tool doesn't
> > > >
> > > > Double space between "." and "This".
> > > >
> > > > > need to know about the details of every type of rdma device.
> > > > >
> > > > > Driver attributes for a rdma resource are in the form of <key,
> > > > > [print_type], value> tuples, where the key is a string and the value can
> > > > > be any supported driver attribute.  The print_type attribute, if
> present,
> > > >
> > > > ditto
> > >
> > > I'll fix these.
> >
> > Fix it if you want, but don't do it because Leon told you to.  A double
> > space after period is perfectly acceptable.
> 
> It is very controversial thing [1],
> 
> "Most style guides indicate that single sentence spacing is proper for
> final or published work today, and most publishers require manuscripts
> to be submitted as they will appear in publication—single
> sentence spaced."
> 
> [1] https://en.wikipedia.org/wiki/Sentence_spacing

We're not writing  a manuscript. 😉  Regardless, I made the changes and they are in v2 of the patch series, which I think is probably ready to merge.

Steve.
