From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: osm_subnet.c: Updated patch to add
 error-reporting to the parsing of opensm.conf
Date: Sun, 18 Mar 2012 14:57:14 +0200
Message-ID: <20120318125714.GE2417@calypso>
References: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5B8B5D0@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5B8B5D0-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:54 Wed 29 Feb     , Mike Heinz wrote:
> I've recently seen two different users on different fabrics make the same
> mistake: They made a syntax error in their opensm.conf file and then couldn't
> figure out why their changes didn't take effect.
> 
> Looking at the code that parses the opensm.conf file, it appears to treat any
> line it cannot parse as a comment and silently passes over it.
> 
> This patch modifies the parse logic as follows:
> 
> 1. Truncate the line at the first '#' character.
> 2. If the result is blank, skip to the next line.
> 3. If the first token in the line can be matched against a known token,
>    process it as usual.
> 4. If the token cannot be matched against a known token, log an error message.
> 
> The result is that if, for example, the user typed "force_link_speed=5" the
> system log will read:
> 
> Feb 24 14:57:09 ifs001 OpenSM[17517]: OpenSM 3.3.13
> Feb 24 14:57:09 ifs001 OpenSM[17517]: Entering DISCOVERING state
> Feb 24 14:57:09 ifs001 OpenSM[17517]: Unrecognized token: "force_link_speed=5"
> Feb 24 14:57:09 ifs001 opensm[17517]: Entering MASTER state
> Feb 24 14:57:09 ifs001 opensm[17517]: SUBNET UP
> .
> .
> .
> 
> In addition, error messages will also be reported to the command line and
> the opensm logfile. For example:
> 
> [root@ifs001]# opensm
> -------------------------------------------------
> OpenSM 3.3.13
>  Reading Cached Option File: /etc/opensm/opensm.conf
> Unrecognized token: "1`243561"
> Command Line Arguments:
>  Log File: /var/log/opensm.log
> -------------------------------------------------
> OpenSM 3.3.13
> 
> Entering DISCOVERING state
> 
> Using default GUID 0x117500007918d2
> Unrecognized token: "1`243561"
> Entering MASTER state
> 
> SUBNET UP
> .
> .
> .
> 
> Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> ---

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
