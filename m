From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 5/5] dapl-2.0 - scm, ucm: add pkey, pkey_index, sl	override
 for QP's
Date: Thu, 17 Jun 2010 11:52:19 +0300
Message-ID: <4C19E243.2020500@voltaire.com>
References: <E3280858FA94444CA49D2BA02341C9830103BF2437@orsmsx506.amr.corp.intel.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF259E4E04A4@orsmsx501.amr.corp.intel.com>	<E3280858FA94444CA49D2BA02341C9830103BF25EB@orsmsx506.amr.corp.intel.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF259E4E065C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF259E4E065C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> The index isn't guaranteed to be the same across all nodes.  If a consumer is going to manually control this, they should really be forced to use the actual pkey.
yes, I saw this confusion in action, for most users pkey index doesn't 
mean anything, it may also change across time, which can break 
scripts/setting to run specific jobs using specific partitions.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
