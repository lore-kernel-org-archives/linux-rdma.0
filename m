From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: Crash in bonding
Date: Tue, 10 Nov 2009 13:44:33 +0200
Message-ID: <4AF95221.2050203@Voltaire.com>
References: <4AEF60AC.6030508@linux.vnet.ibm.com>	<4AEFD866.1040106@voltaire.com> <4AF05C7E.3060804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF05C7E.3060804-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pradeep Satyanarayana wrote:

> The crash is specific to IPoIB, and does not happen with Ethernet slaves.

okay

> Can you explain why you plan to remove this from the newer distros? This is 
> indeed news to me

we plan to remove bonding from --ofed-- as the distro provided bonding supports ipoib, simple as that, what isn't clear here?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
