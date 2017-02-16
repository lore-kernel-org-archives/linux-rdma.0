From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rfc 0/4] Introduce a new helper for parsing ipv[4|6]:port
 to socket address
Date: Thu, 16 Feb 2017 19:53:20 +0200
Message-ID: <8dc41cfc-85b2-fb42-61b0-5be499fa7ad0@grimberg.me>
References: <1487267017-29904-1-git-send-email-sagi@grimberg.me>
 <AD117189-9D24-4C5C-9751-9EA6B27575B1@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AD117189-9D24-4C5C-9751-9EA6B27575B1@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Chuck Lever <chuck.lever@oracle.com>
Cc: linux-nvme@lists.infradead.org, List Linux RDMA Mailing <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hey Chuck,

>> As a side-effect, this set adds ipv6 support for nvme over fabrics.
>> I also converted iscsi target and plan to convert nfs/cifs next but
>> wanted to get some feedback before doing that.
>
> At least NFS/RDMA already supports IPv6. You might not need many
> changes there, but I'll hold off on further comments.

Yea, I wanted to get all the rpc_pton/rpc_ntop (which handle both
ipv4 and ipv6 with scopes) converted to use a common helper.
