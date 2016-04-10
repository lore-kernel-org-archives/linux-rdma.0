From: Christoph Hellwig <hch@infradead.org>
Subject: Re: T10 PI offloading seems to be broken in iser/isert in 4.5/4.6-rc
Date: Sun, 10 Apr 2016 07:37:38 -0700
Message-ID: <20160410143738.GA14101@infradead.org>
References: <20160408221553.GA3716@infradead.org>
 <1460159290.901.5.camel@haakon3.risingtidesystems.com>
 <20160409001456.GA1752@infradead.org>
 <1460169374.5010.4.camel@haakon3.risingtidesystems.com>
 <20160409045846.GA9269@infradead.org>
 <570A147A.1020601@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570A147A.1020601@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 10, 2016 at 11:53:14AM +0300, Sagi Grimberg wrote:
> OK, good to know.
> 
> Since the fabric_prot was added later, I don't think it was properly
> tested (and from what I've seen, not a very interesting use-case).

It's been there for more a year, and once your have non-T10 capable
LUNs in a TPG it gets turned on automatically it seems..

> P.S.
> I'm no longer available in @mellanox.com

I keep messing that all the time by grabbing an address from the list
archives, sorry.  That's why people should only use personal addresses
on mailing lists :)
