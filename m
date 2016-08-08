From: jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/1] Libibumad: Clarify the man page for function umad_get_ca_portguids
Date: Mon,  8 Aug 2016 13:49:57 -0400
Message-ID: <1470678598-27218-1-git-send-email-jay.p.patel@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jay Patel <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jay Patel <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The function umad_get_ca_portguids returns a value of 2 even if there is
only one valid port. The man page for the function only specifies that the
return value is equal to number of port GUIDs actually filled. This may be
confusing for user as it does not specify that there may be invalid entries
in the array.

Any change in interface may break existing user. Hence, clarification is
made in man page that some entries in the array may be invalid and should
be ignored.

Jay Patel (1):
  Libibumad: Clarify the man page for function umad_get_ca_portguids

 man/umad_get_ca_portguids.3 | 3 +++
 1 file changed, 3 insertions(+)

-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
