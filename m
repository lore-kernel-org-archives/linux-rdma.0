From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH v2] IB/mlx4: silence GCC warning
Date: Mon, 25 Feb 2013 09:23:37 -0800
Message-ID: <CAL1RGDWt2cgcwec-iQ9f8-YvC8fO2AncGBfQ2VUgPi3W49bKxg@mail.gmail.com>
References: <1348836538.3626.21.camel@x61.thuisdomein> <511B9A1C.6000402@acm.org>
 <1361437377.1341.33.camel@x61.thuisdomein> <201302241434.17586.jackm@dev.mellanox.co.il>
 <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Paul Bolle <pebolle@tiscali.nl>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Bart Van Assche <bvanassche@acm.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 25, 2013 at 8:54 AM, Roland Dreier <roland@kernel.org> wrote:
> I'm finally noticing that this is in the build_mlx_header() function,
> which is pretty much a slow path.  Certainly another compare isn't
> going to change performance given all the other stuff we do there.
>
> Let me look at the patches that have gone by and see what the cleanest
> way to handle this is.

OK, after playing around a bit, I see that just initializing vlan
doesn't really change the generated code (my gcc at least was already
if effect setting vlan in the generated assembly code), so I'll just
merge that.

 - R.
