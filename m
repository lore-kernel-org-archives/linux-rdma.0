From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH 2/2] IB/hfi1: Handle packets in the theaded handler only
Date: Tue, 10 Oct 2017 15:06:00 -0400
Message-ID: <3003fbfd-6d34-a968-1264-7c16580d5ce6@intel.com>
References: <20171003154920.31566-1-acme@kernel.org>
 <20171003154920.31566-3-acme@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20171003154920.31566-3-acme@kernel.org>
Content-Language: en-US
Sender: linux-rt-users-owner@vger.kernel.org
To: Arnaldo Carvalho de Melo <acme@kernel.org>, bigeasy@linutronix.de
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>, Clark Williams <williams@redhat.com>, Dean Luick <dean.luick@intel.com>, Doug Ledford <dledford@redhat.com>, Julia Cartwright <julia@ni.com>, Kaike Wan <kaike.wan@intel.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On 10/3/2017 11:49 AM, Arnaldo Carvalho de Melo wrote:
> Cc: Clark Williams <williams@redhat.com>
> Cc: Dean Luick <dean.luick@intel.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Julia Cartwright <julia@ni.com>
> Cc: Kaike Wan <kaike.wan@intel.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>
> Cc: Sebastian Sanchez <sebastian.sanchez@intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Mike has been working with these developers off list and has provided a 
slightly different approach. I'm going to let them drive that before I 
add an RB/Ack here.

-Dennis
