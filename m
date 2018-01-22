From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] RDS: Fix rds-ping inducing kernel panic
Date: Tue, 23 Jan 2018 09:17:27 +1100
Message-ID: <CAGXu5jKhPk2MPCvYCOTbcNs7vdej5iuzJbJ9tM92QqXc7MczUA@mail.gmail.com>
References: <20180122112415.GA41074@beast> <2768ae2b-b7de-cf00-c599-4c164a6228be@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <2768ae2b-b7de-cf00-c599-4c164a6228be@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Honggang Li <honli@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Sowmini Varadhan <sowmini.varadhan@oracle.com>, Steve Beattie <sbeattie@ubuntu.com>, Andy Whitcroft <apw@canonical.com>, "David S. Miller" <davem@davemloft.net>, Jay Fenlason <fenlason@redhat.com>, Network Development <netdev@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 4:01 AM, Santosh Shilimkar
<santosh.shilimkar@oracle.com> wrote:
> On 1/22/2018 3:24 AM, Kees Cook wrote:
>>
>> As described in: https://bugzilla.redhat.com/show_bug.cgi?id=822754
>>
>> Attempting an RDS connection from the IP address of an IPoIB interface
>> to itself causes a kernel panic due to a BUG_ON() being triggered.
>> Making the test less strict allows rds-ping to work without crashing
>> the machine.
>>
>> A local unprivileged user could use this flaw to crash the sytem.
>>
> Are you able to reproduce this issue on mainline kernel ?
> IIRC, this sjouldn't happen anymore but if you see it, please
> let me know. Will try it as well. rds-ping on self
> loopback device is often tested and used as well for
> monitoring services in production.

I don't have an RDS test setup, no. But it sounds like kernels without
this patch aren't seeing the problem.

> Am not sure if its applicable anymore. Infact the issue with
> loopback device was due to congestion update and thats been
> already addressed with commit '18fc25c94: {rds: prevent BUG_ON
> triggered on congestion update to loopback}'

That looks very much like it was fixed there. Thanks!

-Kees

-- 
Kees Cook
Pixel Security
