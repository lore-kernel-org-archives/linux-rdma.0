From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ipv6 support in rping
Date: Mon, 21 Sep 2009 10:31:29 -0700
Message-ID: <C221AF93A2FB4C2BBD6052048A69A9DA@amr.corp.intel.com>
References: <OF0B8FD0DB.A642A9F8-ON88257634.007C6289-88257634.007D7D76@us.ibm.com> <4AB746EB.6090104@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AB746EB.6090104-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Pradeep Satyanarayana <pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dwilder-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> Who will be able to help us with this? Need to include the correct level of
>librdmacm
>
>Sean, could you do a 1.0.9 release of librdmacm such that the ipv6 support
>could be distributed?

Sure - I'm assuming that you just need a new package, since the patch for ipv6
for rping is already in the tree.  I should get to this today or tomorrow at the
latest.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
