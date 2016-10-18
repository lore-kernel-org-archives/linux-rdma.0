From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH v3 net-next 00/11] net: Fix netdev adjacency tracking
Date: Tue, 18 Oct 2016 09:58:23 -0600
Message-ID: <295372c1-a359-d560-2856-45e5f0c183be@cumulusnetworks.com>
References: <1476756953-30923-1-git-send-email-dsa@cumulusnetworks.com>
 <20161018.114631.1954199143257806104.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20161018.114631.1954199143257806104.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: jiri@mellanox.com, netdev@vger.kernel.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net, jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
List-Id: linux-rdma@vger.kernel.org

On 10/18/16 9:46 AM, David Miller wrote:
> Series applied, but the recursion is disappointing.
> 
> If we run into problems due to kernel stack depth because of this with
> some configurations (reasonable or not, if we allow it then it can't
> crash the kernel), we will either need to find a way to make this walk
> iterative or revert these changes.

understood.

Since 4.9 is tagged as the next LTS I would like to see the series applied to it at some point - assuming no problems show up with wider exposure in net-next.
