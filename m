From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re:  Crash in bonding
Date: Tue, 03 Nov 2009 09:14:46 +0200
Message-ID: <4AEFD866.1040106@voltaire.com>
References: <4AEF60AC.6030508@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AEF60AC.6030508-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pradeep Satyanarayana wrote:
> This crash was originally reported against Rhel5.4. However, one can recreate this crash quite easily in OFED-1.5 too. 
I understand that you get the crash when working with the RHEL5.4 
bonding driver, correct? does it happen only with IPoIB devices acting 
as the bonding slaves or also with Ethernet devices? Please note that 
with RHEL 5.4 there's no need to use the ofed provided bonding module, 
more over, I believe that the distro provided one is more stable and 
uptodate in this case. Moving forward, ofed bonding support for newish 
distributions is to be removed. Moni, any reason to support bonding/EL 
5.4 in ofed?

Or.

> The steps to recreate the crash are as follows:
> 1. Run traffic (I used ping) on the IB interfaces through the bond master
> 2. ifdown ib0
> 3. ifdown ib1
> 4. modprobe -r ib_ipoib

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
