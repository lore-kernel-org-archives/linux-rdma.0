From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [PATCH net-next] rds: debug: fix null check on static array
Date: Wed, 6 Dec 2017 06:32:11 -0500
Message-ID: <20171206113211.GA8331@oracle.com>
References: <20171206014704.3796-1-bhole_prashant_q7@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171206014704.3796-1-bhole_prashant_q7@lab.ntt.co.jp>
Sender: netdev-owner@vger.kernel.org
To: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
Cc: "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On (12/06/17 10:47), Prashant Bhole wrote:
> 
> t_name cannot be NULL since it is an array field of a struct.
> Replacing null check on static array with string length check using
> strnlen()

t_name is always initialized for all rds transports today,  and would
be all zeros unless someone stomped over that memory (in which case
there could be more serious issues than a busted debug string) but
it's good  to be safe and check I suppose.

Acked-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>

--Sowmini
