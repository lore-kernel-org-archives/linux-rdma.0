From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: T10 PI offloading seems to be broken in iser/isert in 4.5/4.6-rc
Date: Sun, 10 Apr 2016 18:30:20 +0300
Message-ID: <570A718C.4070107@grimberg.me>
References: <20160408221553.GA3716@infradead.org>
 <1460159290.901.5.camel@haakon3.risingtidesystems.com>
 <20160409001456.GA1752@infradead.org>
 <1460169374.5010.4.camel@haakon3.risingtidesystems.com>
 <20160409045846.GA9269@infradead.org> <570A147A.1020601@grimberg.me>
 <20160410143738.GA14101@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160410143738.GA14101@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>> Since the fabric_prot was added later, I don't think it was properly
>> tested (and from what I've seen, not a very interesting use-case).
>
> It's been there for more a year, and once your have non-T10 capable
> LUNs in a TPG it gets turned on automatically it seems..

Yea, but I'm not aware of anyone running non-PI together with PI.
Usually people use either/or (although it can make sense to mix
if you have different classes of data sets).
