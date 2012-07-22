From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/qib: Added congestion control agent implementation
Date: Sun, 22 Jul 2012 08:44:00 +0300
Message-ID: <500B9320.7080803@mellanox.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org> <20120719130403.4706.24376.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120719130403.4706.24376.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/19/2012 4:04 PM, Mike Marciniszyn wrote:
> Added a congestion control agent in the driver that handles
> gets and sets from the congestion control manager in the
> fabric for the Performance Scale Messagin (PSM) library.

Hi Mike,

Nice doing.

Can you elaborate a little on the role/usage of the sysfs entries this 
patch adds? I wasn't sure to follow, basically, I thought IBTA CCA 
defined thing such that one can set/get anything CC related  through 
MADs, isn't that?

Also, it seems that lots (if not most or all) the CC MADs related code  
is general and can (should) easily be moved to be under the IB core 
headers and sources, agree? We can do that as little cleanup later, 
after the bigger picture is realized here.

Or.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
