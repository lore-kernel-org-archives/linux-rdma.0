From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: add support of reload net topology file
Date: Mon, 01 Mar 2010 17:38:47 +0200
Message-ID: <4B8BDF87.3020107@gmail.com>
References: <4B7C0256.7080505@voltaire.com> <20100227152212.GG13592@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100227152212.GG13592@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 16:51 Wed 17 Feb     , Doron Shohamd wrote:
>> add new command 'reload' in order to reload net topology file
> 
> The same can be achieved by restarting ibsim. So what is the purpose of
> such "reload on the fly" functionality?

Restarting ibsim on the fly closes all client connections and opensm for example 
has no reconnect. That means we have to restart opensm as well.
The idea was to change topology without opensm restart.

> 
> And if it is really needed then I suppose that you will need to handle
> somehow an existing client connections. For example if SM is running its
> port will go to INIT state (or even disappear) silently, no?

it is up to the user to provide a topology file in which the opensm port is still 
connected. It is true that port states will got to INIT, but I don't see any problem with
that since opensm will bring up the fabric when it receives SIGHUP or trap from simulator.
We can add the trap generation to this patch.
what do you think?

Eli
> 
> Sasha
> 
>> Signed-off-by: Doron Shoham <dorons-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>> ---
>>  ibsim/ibsim.c   |   21 ++++++++++++++++++---
>>  ibsim/sim_cmd.c |    6 ++++++
>>  2 files changed, 24 insertions(+), 3 deletions(-)
>>
>> diff --git a/ibsim/ibsim.c b/ibsim/ibsim.c
>> index e720f0d..98be195 100644
>> --- a/ibsim/ibsim.c
>> +++ b/ibsim/ibsim.c
>> @@ -73,6 +73,8 @@ extern int ignoreduplicate;
>>  int ibdebug;
>>  int parsedebug;
>>  int simverb;
>> +FILE *infile, *outfile;
>> +char *netfile;
>>  
>>  static Client clients[IBSIM_MAX_CLIENTS];
>>  static int simctl = -1;
>> @@ -82,6 +84,13 @@ static int listen_to_port = IBSIM_DEFAULT_SERVER_PORT;
>>  static int remote_mode = 0;
>>  static char* socket_basename;
>>  
>> +extern int 	netnodes, netswitches, netports, netaliases;
>> +extern Node *nodes;
>> +extern Switch *switches;
>> +extern Port *ports;
>> +extern Port **lids;
>> +extern char (*aliases)[NODEIDLEN + NODEPREFIX + 1];	// aliases map format: "%s@%s"
>> +
>>  static size_t make_name(union name_t *name, uint32_t addr, unsigned short port,
>>  			const char *fmt, ...)
>>  {
>> @@ -553,8 +562,15 @@ int sim_cmd_file(FILE * f, char *s)
>>  	return 0;
>>  }
>>  
>> -static int sim_init_net(char *netconf, FILE * out)
>> +int sim_init_net(char *netconf, FILE * out)
>>  {
>> +	netnodes = netswitches = netports = netaliases = 0;
>> +	memset(nodes, 0, maxnetnodes*sizeof(*nodes));
>> +	memset(switches, 0, maxnetswitches*sizeof(*switches));
>> +	memset(ports, 0, maxnetports*sizeof(*ports));
>> +	memset(lids, 0, maxlinearcap*sizeof(*lids));
>> +	memset(aliases, 0, maxnetaliases*sizeof(*aliases));
>> +
>>  	DEBUG("reading %s", netconf);
>>  	if (read_netconf(netconf, out) < 0)
>>  		return -1;
>> @@ -716,8 +732,7 @@ int main(int argc, char **argv)
>>  {
>>  	extern int alloc_core(void);
>>  	extern void free_core(void);
>> -	char *outfname = 0, *netfile;
>> -	FILE *infile, *outfile;
>> +	char *outfname = 0;
>>  	int status;
>>  
>>  	static char const str_opts[] = "rf:dpvIsN:S:P:L:M:l:Vhu";
>> diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
>> index 6d3a893..51a407c 100644
>> --- a/ibsim/sim_cmd.c
>> +++ b/ibsim/sim_cmd.c
>> @@ -49,12 +49,15 @@
>>  #define DEBUG	if (simverb > 1 || ibdebug) IBWARN
>>  
>>  extern void free_core(void);
>> +extern int sim_init_net(char *, FILE *);
>>  
>>  extern Node *nodes;
>>  extern Switch *switches;
>>  extern Port *ports;
>>  extern Port **lids;
>>  extern int netnodes, netports, netswitches;
>> +extern char *netfile;
>> +extern FILE *outfile;
>>  
>>  #define NAMELEN	NODEIDLEN
>>  
>> @@ -822,6 +825,7 @@ static int dump_help(FILE * f)
>>  		);
>>  	fprintf(f,
>>  		"\tBaselid \"nodeid\"[port] <lid> [lmc] : change port's lid (lmc)\n");
>> +	fprintf(f, "\tReload : reload net topology file\n");
>>  	fprintf(f, "\tVerbose [newlevel] - show/set simulator verbosity\n");
>>  	fprintf(f, "\t\t\t0 - silent\n");
>>  	fprintf(f, "\t\t\t1 - debug verbose\n");
>> @@ -907,6 +911,8 @@ int do_cmd(char *buf, FILE *f)
>>  	 */
>>  	else if (!strncasecmp(line, "ReLink", cmd_len))
>>  		r = do_relink(f, line);
>> +	else if (!strncasecmp(line, "Reload", cmd_len))
>> +		r = sim_init_net(netfile, outfile);
>>  	else if (*line != '\n' && *line != '\0')
>>  		fprintf(f, "command \'%s\' unknown - skipped\n", line);
>>  
>> -- 
>> 1.5.5
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
