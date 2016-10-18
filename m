From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: SQ overflow seen running isert traffic
Date: Tue, 18 Oct 2016 14:03:56 -0500
Message-ID: <01ab01d22972$6031c250$209546f0$@opengridcomputing.com>
References: <20160927070157.GA13140@chelsio.com> <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me> <20161017111655.GA21245@chelsio.com> <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com> <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me> <20161018112801.GA3117@chelsio.com> <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me> <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com> <20161018161313.GC24189@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20161018161313.GC24189@obsidianresearch.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>
Cc: 'Sagi Grimberg' <sagi@grimberg.me>, 'Potnuri Bharat Teja' <bharat@chelsio.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> On Tue, Oct 18, 2016 at 09:34:33AM -0500, Steve Wise wrote:
> 
> > 1) we believe the iSER + RW API correctly sizes the SQ, yet we're seeing SQ
> > overflows.  So the SQ sizing needs more investigation.
> 
> NFS had this sort of problem - in that case it was because the code
> was assuming that a RQ completion implied SQ space - that is not
> legal, only direct completions from SQ WCs can guide available space
> in the SQ..
> 

Agreed.  And this could be the case Bharat is hitting. (I wonder if there is a
clever way we can tell?)  I don't see I the code that isert flow controls SQ WR
submission based on SQ completions.  

It would be nice to have some core API, maybe in rdma-rw, that could handle this
by queuing and processing when the SQ has resources...

Steve.
