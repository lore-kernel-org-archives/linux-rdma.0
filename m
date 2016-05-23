From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH 1/1] Staging: rdma: hfi1: rc.c: Fixed coding style issues
Date: Mon, 23 May 2016 08:39:05 -0400
Message-ID: <20160523123904.GB16764@phlsvsds.ph.intel.com>
References: <1463985362-8429-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463985362-8429-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: gregkh@linuxfoundation.org, infinipath@intel.com, dledford@redhat.com, sean.hefty@intel.com, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 23, 2016 at 12:06:01PM +0530, Shyam Saini wrote:
>Fixed following checkpatch.pl warnings:
>  Prefer 'unsigned int' to bare use of 'unsigned'
>  Prefer READ_ONCE(<FOO>) over ACCESS_ONCE(<FOO>)

In general please don't fix two types of issues in the same patch. Also, as 
to the unsinged -> unsigned int, the linux-rdma maintainer has already said 
we don't really want all of the code churn for this [1].

I suggest to respin this patch with just the ACCESS_ONCE->READ_ONCE change 
so that can be reviewed on it's own.

[1] http://marc.info/?l=linux-rdma&m=146308474205407&w=2

-Denny
