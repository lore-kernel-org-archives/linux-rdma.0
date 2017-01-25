From: Selvin Xavier <selvin.xavier@broadcom.com>
Subject: Re: [PATCH for bnxt_re V4 17/21] RDMA/bnxt_re: Handling dispatching
 of events to IB stack
Date: Wed, 25 Jan 2017 14:33:36 +0530
Message-ID: <CA+sbYW2=Kfe6gUpiJTeLErXGTHzVacCYrWRNgewe9mJKH6ov4Q@mail.gmail.com>
References: <1482320530-5344-1-git-send-email-selvin.xavier@broadcom.com>
 <1482320530-5344-18-git-send-email-selvin.xavier@broadcom.com> <20170124121801.GG6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170124121801.GG6005@mtr-leonro.local>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>, Michael Chan <michael.chan@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 24, 2017 at 5:48 PM, Leon Romanovsky <leon@kernel.org> wrote:
> All callers to this function in this patch set qp_wait to be false.
> Do you have in following patches qp_wait == true?
> I'm curious because of your msleep below.


Thanks for pointing it out. Driver in our internal tree had one more
condition which has a qp_wait == true condition. I missed to remove
this before posting upstream. Will include this in V5
