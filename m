From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx4: Reduce SRIOV multicast cleanup
 warning message to debug level
Date: Mon, 24 Apr 2017 12:10:28 -0400
Message-ID: <1493050228.3041.36.camel@redhat.com>
References: <20170321105706.9355-1-leon@kernel.org>
         <20170321105706.9355-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170321105706.9355-2-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Jack Morgenstein <jackm@dev.mellanox.co.il>, "# v3 . 4+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-03-21 at 12:57 +0200, Leon Romanovsky wrote:
> From: Jack Morgenstein <jackm@dev.mellanox.co.il>
> 
> A warning message during SRIOV multicast cleanup should have actually
> been
> a debug level message. The condition generating the warning does no
> harm
> and can fill the message log.
> 
> In some cases, during testing, some tests were so intense as to swamp
> the
> message log with these warning messages, causing a stall in the
> console
> message log output task. This stall caused an NMI to be sent to all
> CPUs
> (so that they all dumped their stacks into the message log).
> Aside from the message flood causing an NMI, the tests all passed.
> 
> Once the message flood which caused the NMI is removed (by reducing
> the
> warning message to debug level), the NMI no longer occurs.
> 
> Sample message log (console log) output illustrating the flood and
> resultant NMI (snippets with comments and modified with ... instead
> of hex digits, to satisfy checkpatch.pl):

[ snip ]

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
