From: Andy Grover <agrover@redhat.com>
Subject: SRPT GID format (was Re: Error with /ib_srpt create)
Date: Fri, 01 Feb 2013 16:18:28 -0800
Message-ID: <510C5B54.2000506@redhat.com>
References: <18A7B34BFC9FAE47A0E3D95D075EECE238A0E3EE@exmbx11> <1359754777.6300.109.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1359754777.6300.109.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 02/01/2013 01:39 PM, Nicholas A. Bellinger wrote:
> I believe this version of rtslib's ib_srpt.spec file is using the
> pre-mainline '0x0000' prefix instead of '0xfe80' for port GIDs with the
> target endpoint name in /sys/kernel/config/target/srpt/$WWPN/
>
> This was a change to ib_srpt.spec's wwn_from_files_filter sed usage, for
> which the upstream patch can be found here:
>
> http://www.risingtidesystems.com/git/?p=rtslib.git;a=commitdiff;h=6666d30fb1d90b9195d98c8fe8fcec2708362873

Hi IB people,

Are these gids always going to be fe80+lots of zeros+eui64?

If not, what limitations should we use to ensure this value is good, 
when creating srpt endpoints?

Thanks -- Regards -- Andy
