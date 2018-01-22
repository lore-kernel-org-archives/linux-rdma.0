From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH] RDS: Fix rds-ping inducing kernel panic
Date: Mon, 22 Jan 2018 09:01:43 -0800
Message-ID: <2768ae2b-b7de-cf00-c599-4c164a6228be@oracle.com>
References: <20180122112415.GA41074@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180122112415.GA41074@beast>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Honggang Li <honli@redhat.com>, linux-kernel@vger.kernel.org, Sowmini Varadhan <sowmini.varadhan@oracle.com>, Steve Beattie <sbeattie@ubuntu.com>, Andy Whitcroft <apw@canonical.com>, "David S. Miller" <davem@davemloft.net>, Jay Fenlason <fenlason@redhat.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 1/22/2018 3:24 AM, Kees Cook wrote:
> As described in: https://bugzilla.redhat.com/show_bug.cgi?id=822754
> 
> Attempting an RDS connection from the IP address of an IPoIB interface
> to itself causes a kernel panic due to a BUG_ON() being triggered.
> Making the test less strict allows rds-ping to work without crashing
> the machine.
> 
> A local unprivileged user could use this flaw to crash the sytem.
>
Are you able to reproduce this issue on mainline kernel ?
IIRC, this sjouldn't happen anymore but if you see it, please
let me know. Will try it as well. rds-ping on self
loopback device is often tested and used as well for
monitoring services in production.

> I think this fix was written by Jay Fenlason <fenlason@redhat.com>,
> and extracted from the RedHat kernel patches here:
> 
> https://oss.oracle.com/git/gitweb.cgi?p=redpatch.git;a=commitdiff;h=c7b6a0a1d8d636852be130fa15fa8be10d4704e8
>
It was part of redhat patched kernel but not carried in shipping
Oracle UEK kernels at least afaik.

> This fix appears to have been carried by at least RedHat, Oracle, and
> Ubuntu for several years.
>
> CVE-2012-2372
> 
> Reported-by: Honggang Li <honli@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is what I get for researching CVE lifetimes...
Am not sure if its applicable anymore. Infact the issue with
loopback device was due to congestion update and thats been
already addressed with commit '18fc25c94: {rds: prevent BUG_ON
triggered on congestion update to loopback}'

Regards,
Santosh
