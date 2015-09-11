From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Fri, 11 Sep 2015 11:03:02 -0400
Message-ID: <20150911150302.GR8114@mtj.duckdns.org>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <20150908152340.GA13749@mtj.duckdns.org>
 <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
 <20150910164946.GH8114@mtj.duckdns.org>
 <CAG53R5XyfQxrA+FUKFaZi7ZBhSz-SW6eGkGUZpdo6hUTBkAO-g@mail.gmail.com>
 <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org>
 <CAG53R5WW8QRHmopva260BPgvfH3xeq16d2ChGTcEtBwFbhNdfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5WW8QRHmopva260BPgvfH3xeq16d2ChGTcEtBwFbhNdfw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello, Parav.

On Fri, Sep 11, 2015 at 10:13:59AM +0530, Parav Pandit wrote:
> > My uneducated suspicion is that the abstraction is just not developed
> > enough.  It should be possible to virtualize these resources through,
> > most likely, time-sharing to the level where userland simply says "I
> > want this chunk transferred there" and OS schedules the transfer
> > prioritizing competing requests.
> 
> Tejun,
> That is such a perfect abstraction to have at OS level, but not sure
> how much close it can be to bare metal RDMA it can be.
> I have started discussion on that front as well as part of other
> thread, but its certainly long way to go.
> Most want to enjoy the performance benefit of the bare metal
> interfaces it provides.

Yeah, sure, I'm not trying to say that rdma needs or should do that.

> Such abstraction that you mentioned, exists, the only difference is
> instead of its OS as central entity, its the higher level libraries,
> drivers and hw together does it today for the applications.

But more that having resource control in the OS and actual arbitration
higher up in the stack isn't likely to lead to an effective resource
distribution scheme.

> > You kinda have to decide that upfront cuz it gets baked into the
> > interface.
> 
> Well, all the interfaces are not yet defined. Except the test and

I meant the cgroup interface.

> benchmark utilities, real world applications wouldn't really bother
> much about which device are they are going through.

Weights can work fine across multiple devices.  Hard limits don't.  It
just doesn't make any sense.  Unless you can exclude multiple device
scenarios, you'll have to implement per-device limits.

Thanks.

-- 
tejun
