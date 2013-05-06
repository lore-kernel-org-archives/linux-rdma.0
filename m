From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [ANNOUNCE] SRP: ProfitBricks publishes its SRP Initiator patches
Date: Mon, 06 May 2013 11:44:17 +0200
Message-ID: <51877B71.3080202@acm.org>
References: <5167EDC8.3030909@profitbricks.com> <CACaajQs0PswMb5KhpSkE1=_Sd1SwX2BznZP9x1FCkEk6ukJYrA@mail.gmail.com> <5183A355.5090401@acm.org> <CACaajQtQk0YJ3g0G5PyOue0qG3SzhaW3qmXj_TLqYDVqzKwJXQ@mail.gmail.com> <51876D79.50003@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51876D79.50003-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/06/13 10:44, Sebastian Riemer wrote:
> Sorry Bart, but a reconnect with just the commit message
> "IB/srp: Add kernel-level transport layer recovery" and no further
> description isn't very trustworthy for me. I also wonder why you need so
> much locking.

Hello Sebastian,

There is a very good reason for all that locking: during device removal 
the rport structure is freed before SCSI host removal finished. So when 
converting a SCSI host pointer into an rport pointer protection is 
needed against device removal. The current approach in the 
ib_srp-backport repository is to realize that protection via locking. 
I'm currently reworking that approach into protection via reference 
counting such that it is guaranteed that the rport remains to exist 
until scsi_remove_device() has finished. That will allow to eliminate 
several locking statements.

Sorry for the terse patch descriptions - I had not expected that anyone 
would try to understand the patches ib_srp-backport repository and use 
these as a basis for further work.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
