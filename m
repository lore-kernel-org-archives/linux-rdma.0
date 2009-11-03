From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Crash in bonding
Date: Tue, 03 Nov 2009 08:38:22 -0800
Message-ID: <4AF05C7E.3060804@linux.vnet.ibm.com>
References: <4AEF60AC.6030508@linux.vnet.ibm.com> <4AEFD866.1040106@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AEFD866.1040106-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Pradeep Satyanarayana wrote:
>> This crash was originally reported against Rhel5.4. However, one can
>> recreate this crash quite easily in OFED-1.5 too. 
> I understand that you get the crash when working with the RHEL5.4
> bonding driver, correct? 
We used the one that comes native with the Rhel5.4 distro. I also used installed
OFED-1.5 on Rhel5.4 and still see the same problem.

does it happen only with IPoIB devices acting
> as the bonding slaves or also with Ethernet devices? 

I am not exactly sure what you are hinting at. Simplest case is to use IPoIB
devices as slaves and with the steps below the crash occurs. The crash is specific
to IPoIB, and does not happen with Ethernet slaves.

Please note that
> with RHEL 5.4 there's no need to use the ofed provided bonding module,
> more over, I believe that the distro provided one is more stable and
> uptodate in this case. 
We used what is natively available with Rhel5.4.

Moving forward, ofed bonding support for newish
> distributions is to be removed. Moni, any reason to support bonding/EL
> 5.4 in ofed?

Can you explain why you plan to remove this from the newer distros? This is 
indeed news to me.

Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
