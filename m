From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22
 got worse on 4.7.0
Date: Sat, 20 Aug 2016 22:10:07 -0400
Message-ID: <CA+X5Wn7KH9d3B7ERbo+0Wb-M6QR+G3-yUzEBXAQTZtp=9fnKdw@mail.gmail.com>
References: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 20, 2016 at 1:21 AM, james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The initial SRP_LOGIN_REQ around 66.3 is iPXE.  The others around 95.5
> are linux.  As before, add_target attempts are run on the initiator
> between these, showing the "path rec status -22" error, but no
> messages are logged on the target for those.
>
> But, starting with ib_srpt 4.7.0, immediately after the linux SRP
> connection starts the "sending cmd response failed" messages.

Interestingly (to me) if I boot iPXE and run the sanhook command to
initiate the SRP connection, and reboot the initiator so the SRP
connection is never closed or re-attempted, I can in the second iPXE
start run the sanhook command again and properly initate a new SRP
connection without any type of delay or error.  In this case, the
target shows:

=====
[  345.321267] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 80 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[  345.327900] ib_srpt truncated sense data from 96 to 44 bytes
[  438.994377] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 80 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[  438.994389] ib_srpt Relogin - closed existing channel
0x1d534b0003c902000002c903004b5275
[  438.994414] ib_srpt Received CM DREP message for ch
0x1d534b0003c902000002c903004b5275-522.
=====

The initial SRP_LOGIN_REQ around 345.3 is the first iPXE, and the
second SRP_LOGIN_REQ around 438.9 is the second iPXE after the reboot.
Then attempting to proceed with the boot, as before, winds up with the
target showing linux's SRP_LOGIN_REQ and the corresponding "sending
cmd response failed for tag" around 513.6.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
