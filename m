From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: SQ overflow seen running isert traffic
Date: Thu, 20 Oct 2016 11:34:34 +0300
Message-ID: <f7a4b395-1786-3c7a-7639-195e830db5ad@grimberg.me>
References: <20160927070157.GA13140@chelsio.com>
 <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
 <20161017111655.GA21245@chelsio.com>
 <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>
 <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
 <20161018112801.GA3117@chelsio.com>
 <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
 <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com>
 <20161018161313.GC24189@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20161018161313.GC24189@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Steve Wise <swise@opengridcomputing.com>
Cc: 'Potnuri Bharat Teja' <bharat@chelsio.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hey Jason,

>> 1) we believe the iSER + RW API correctly sizes the SQ, yet we're seeing SQ
>> overflows.  So the SQ sizing needs more investigation.
>
> NFS had this sort of problem - in that case it was because the code
> was assuming that a RQ completion implied SQ space - that is not
> legal, only direct completions from SQ WCs can guide available space
> in the SQ..

Its not the same problem. iser-target does not tie SQ and RQ spaces.
The origin here is the difference between IB/RoCE and iWARP and the
chelsio HW that makes it hard to predict the SQ correct size.

iWARP needs extra registration for rdma reads and the chelsio device
seems to be limited in the number of pages per registration so this
configuration will need a larger send queue.

Another problem is that we don't have a correct retry flow.

Hopefully we can address that in the RW API which is designed to hide
these details from the ULP...
