From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: SQ overflow seen running isert traffic
Date: Wed, 2 Nov 2016 12:03:30 -0500
Message-ID: <018001d2352b$097fec10$1c7fc430$@opengridcomputing.com>
References: <20160927070157.GA13140@chelsio.com>         <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>         <20161017111655.GA21245@chelsio.com>         <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>         <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>         <20161018112801.GA3117@chelsio.com>         <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>         <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com> <1477885208.27946.8.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1477885208.27946.8.camel@haakon3.risingtidesystems.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: "'Nicholas A. Bellinger'" <nab@linux-iscsi.org>
Cc: 'Sagi Grimberg' <sagi@grimberg.me>, 'Potnuri Bharat Teja' <bharat@chelsio.com>, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> > So to sum up - 2 issues:
> >
> > 1) we believe the iSER + RW API correctly sizes the SQ, yet we're seeing SQ
> > overflows.  So the SQ sizing needs more investigation.
> >
> > 2) if the SQ is full, then the iSER/target code is supposed to resubmit.  And
> > apparently that isn't working.
> >
> 
> For #2, target-core expects -ENOMEM or -EAGAIN return from fabric driver
> callbacks to signal internal queue-full retry logic.  Otherwise, the
> extra se_cmd->cmd_kref response SCF_ACK_KREF is leaked until session
> shutdown and/or reinstatement occurs.
> 
> AFAICT, Potunri's earlier hung task with v4.8.y + ABORT_TASK is likely
> the earlier v4.1+ regression:
> 
> https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c6d6afd
> b1e3e
> 
> That said, there is room for improvement in target-core queue-full error
> signaling, and iscsi-target/iser-target callback error propagation.
> 
> Sending out a series shortly to address these particular items.
> Please have a look.
> 

Hey Nicholas,  Bharat is out until next week.  He'll try this all out next week and report back.

Thanks!

Steve.
