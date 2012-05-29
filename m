From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
Date: Tue, 29 May 2012 14:51:58 -0700
Message-ID: <4FC544FE.3000204@sgi.com>
References: <4FC53AAA.3060203@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FC53AAA.3060203@ddn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Karandeep Chahal <kchahal@ddn.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com
List-Id: linux-rdma@vger.kernel.org

Did you subsequently reconnect the target and confirm appropriate behavior?


On 05/29/2012 02:07 PM, Karandeep Chahal wrote:
> Subject: [PATCH] Infiniband srp fast failover patch. Currently ib_srp does
>    not do anything on receiving a DREQ from the target, it
>    only sends a response back. Further it also does not
>    monitor port (down) events. I have patched srp to remove
>    scsi devices when a port down event is received or if the
>    target sends a DREQ. Currently even though the target
>    notifies the initiator of its intentions of going away, the
>    initiator ignores that information. Later the initiator
>    gets upset when the devices "suddenly" disappear resulting
>    in srp initiating an error recovery process which takes a
>    long time. This caused high failover latencies as compared
>    to fibre channel. In my experiments with RHEL 6.0 and 6.2 I
>    encountered failover time that exceeded 2 minutes and 20
>    seconds (despite tweaking /etc/multipath.conf and
>    /sys/block/<>/timeout). With this patch the failover takes
>    30 seconds. I have tested this patch with and without a
>    switch.
>
> Yours, etc.
> Karan
>
