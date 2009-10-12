From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ofa-general][PATCH 0/4] SRP fail-over faster
Date: Mon, 12 Oct 2009 15:56:33 -0700
Message-ID: <4AD3B421.1050704@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090004080102040207000405"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------090004080102040207000405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------090004080102040207000405
Content-Type: message/rfc822;
 name="[ofa-general][PATCH 0/4] SRP fail-over faster.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[ofa-general][PATCH 0/4] SRP fail-over faster.eml"

Message-ID: <4AD3B1C6.9050400-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Mon, 12 Oct 2009 15:46:30 -0700
From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: OF General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>,
 Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [ofa-general][PATCH 0/4] SRP fail-over faster
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Testing srp fail-over with dm-multipath/multipathd/srp_daemon, the 
current srp implementation will take average 3-5 minutes to complete the 
error recovery before return DID_BAD_TARGET so that dm-multipath can 
switch to other paths. During this error recovery, there is no I/O 
happening (old and new I/Os)

The following patches attempt to help srp fail-over faster and 
controllable. It introduces srp_dev_loss_tmo module parameter, so that, 
srp will fail-over after srp_dev_loss_tmo expired.The minimum value for 
srp_dev_loss_tmo is 60 seconds.

Patch 1/4: recreate qp and cq at reconnect instead of reuse them
Patch 2/4: disconnect request without wait.
Patch 3/4: introducing srp_dev_loss_tmo, creating a timer on qp_error event.
Patch 4/4: setting up async event handler to handle local port up/down 
events

The fail-over will be more accurate on local port up/down events (ie. 
someone pull the cable connect local port to switch), it is less 
accurate on target port up/down events (ie. someone pull the cable 
connect target port to switch)

To be accurate on target port up/down events, it requires to change 
srp_daemon to catch the event of IB target port joining/leaving the 
fabric, then pass these event down to srp driver, srp driver need to 
implement entry points to receive these events and act upon them. These 
are missed on this attempt

thanks,
-vu


--------------090004080102040207000405--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
