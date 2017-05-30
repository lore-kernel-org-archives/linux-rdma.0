From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: How do I generate and set a GUID on an Ethernet VF with ConnectX-4?
Date: Tue, 30 May 2017 11:55:20 -0600
Message-ID: <CAANLjFoHJhCJpZ+9uogHE4nSLkrdTRbGgS4mO5un_M+mNYdmCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

One problem we found with rping is that when the GUID is '0', it
fails. However, all of the VFs that are created are created with a '0'
GUID. How do I generate a GUID that will not conflict for the VFs?
Once I have a generated GUID, how do I set it on a VF using the inbox
drivers? I can't find a /sys entry that will allow me to write it and
the one mentioned in the Mellanox OFED doesn't exist.

I'll need to find a way to script this as part of my udev rules that
adds the VFs.

Thank you,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
